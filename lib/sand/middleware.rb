module Sand
  class RequestMethods
    attr_accessor :env
    include Sand::Helpers

    def initialize(env)
      @env = env
    end
  end

  class Middleware
    attr_reader :app, :env, :options, :response

    DEFAULT_OPTIONS = {
      pass: []
    }.freeze

    def initialize(app, options = {})
      @env = nil
      @app = app
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def passed?
      return true if options[:pass].any? { |r| r =~ env['REQUEST_PATH'] }
      return true if env['sand.pass'] == true || env['sand.scoped'] || env['sand.authorized'] == true # rubocop:disable Metrics/LineLength
      false
    end

    def call(env)
      @env = env
      env['sand'] = RequestMethods.new(env)

      result = app.call(env)

      return result if passed?
      raise Sand::AuthorizationNotPerformed
    end
  end
end
