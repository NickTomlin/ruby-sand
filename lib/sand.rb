require 'sand/version'
require 'sand/policy_finder'
require 'sand/util'
require 'sand/helpers'
require 'sand/middleware'

module Sand
  POLICY_SUFFIX = 'Policy'.freeze

  class Error < StandardError; end
  class NotDefinedError < Error; end
  class AuthorizationNotPerformed < Error; end
  class ScopeNotPerformed < Error; end

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
      raise NotAuthorizedError.new(policy: policy, record: record, query: query) # rubocop:disable Style/RaiseArgs, Metrics/LineLength
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
end
