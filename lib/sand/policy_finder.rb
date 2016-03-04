module Sand
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
      klass = Util.constantize(klass) if klass.is_a?(String)
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
  end
end
