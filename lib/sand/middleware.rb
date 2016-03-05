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

    def initialize(app)
      @env = nil
      @app = app
    end

    def call(env)
      @env = env
      env['sand'] = RequestMethods.new(env)

      result = app.call(env)

      if env['sand.pass'] == true || env['sand.scoped'] || env['sand.authorized'] == true
        result
      else
        raise Sand::AuthorizationNotPerformed
      end
    end
  end
end
