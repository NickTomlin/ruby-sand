require 'sand/version'
require 'sand/middleware'

module Sand
  POLICY_SUFFIX = "Policy"

  class Error < StandardError; end
  class NotDefinedError < Error; end
  class NotAuthorizedError < Error
    attr_reader :record, :query, :policy

    def initialize(options)
      @record = options[:record]
      @query = options[:query]
      @policy = options[:policy]

      super("not allowed to #{query} this #{record.inspect}")
    end
  end

  def self.authorize(user, record, query)
    policy = policy!(user, record)

    unless policy.public_send(query)
      raise NotAuthorizedError.new(policy: policy, record: record, query: query)
    end

    true
  end

  def self.policy!(user, record)
    policy = PolicyFinder.new(record).policy!
    policy.new(user, record)
  end

  def self.policy_scope(user, scope)
    policy_scope = PolicyFinder.new(scope).scope!
    policy_scope.new(user, scope).resolve
  end

  class PolicyFinder
    def initialize(object)
      @object = object
    end

    def scope!
      scope = policy!::Scope
      rescue NameError
        raise NotDefinedError
      scope
    end

    def policy!
      klass = find
      klass = constantize(klass) if klass.is_a?(String)
      rescue NameError
        raise NotDefinedError
      klass
    end

    private

    def find
      klass = @object
      # this is simplistic
      if @object.nil?
        return klass
      end

      if @object.is_a?(Symbol)
        klass = @object.to_s.camelize
      end

      "#{klass}#{POLICY_SUFFIX}"
    end

    def constantize(str = '')
      str.split("::").inject(Module) {|acc, val| acc.const_get(val)}
    end
  end
end
