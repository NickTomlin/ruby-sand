module Sand
  class Middleware
    attr_reader :app, :env, :options, :response

    def initialize(app)
      @env = nil
      @app = app
    end

    def call(env)
      @env = env

      env.policy_scope = sand_policy_scope
    end

    def sand_policy_scope(user, record)
      scope = PolicyFinder.new(record).scope!
      scope.new(user, record).resolve if scope
    end
  end
end
