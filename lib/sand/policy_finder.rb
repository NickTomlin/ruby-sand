module Sand
  class PolicyFinder
    POLICY_SUFFIX = 'Policy'.freeze

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

    # rubocop:disable Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize, Metrics/LineLength
    def find
      klass = @object
      return klass if @object.nil?

      if @object.respond_to?(:sand_policy)
        @object.sand_policy
      elsif @object.class.respond_to?(:sand_policy)
        @object.sand_policy
      else
        klass = if @object.is_a?(Symbol)
                  @object.to_s.camelize
                elsif @object.respond_to?(:model)
                  @object.model
                elsif @object.respond_to?(:model_class)
                  @object.model_class
                else
                  @object.to_s
                end
        "#{klass}#{POLICY_SUFFIX}"
      end
    end
  end
end
