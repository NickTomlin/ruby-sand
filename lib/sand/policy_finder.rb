module Sand
  class PolicyFinder
    def initialize(object)
      @object = object
    end

    def scope!
      policy!::Scope
    rescue NameError
      raise NotDefinedError
    end

    def policy!
      klass = find
      klass = Util.constantize(klass) if klass.is_a?(String)
      klass
    rescue NameError
      raise NotDefinedError
    end

    private

    def find
      klass = @object
      # this is simplistic
      return klass if @object.nil?

      klass = @object.to_s.camelize if @object.is_a?(Symbol)

      "#{klass}#{POLICY_SUFFIX}"
    end
  end
end
