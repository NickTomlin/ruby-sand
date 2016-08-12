module Sand
  class RequestMethods
    attr_accessor :env
    include Sand::Helpers

    def initialize(env)
      @env = env
    end
  end

  class Middleware
    attr_reader :app, :options, :response

    DEFAULT_OPTIONS = {
      pass: []
    }.freeze

    def initialize(app, options = {})
      @app = app
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def passed?(env)
      return true if options[:pass].any? { |r| r =~ env['PATH_INFO'] }
      return true if env['sand.pass'] == true || env['sand.scoped'] || env['sand.authorized'] == true # rubocop:disable Metrics/LineLength
      false
    end

    def call(env)
      env['sand'] = RequestMethods.new(env)

      result = app.call(env)

      return result if passed?(env)
      raise Sand::AuthorizationNotPerformed
    end
  end
end
