module Sand
  # Helpers to be mixed into a rack app
  module Helpers
    # Helpers expect to be mixed into a class where env is available
    def policy_scope(user, record)
      scoped!
      scope = PolicyFinder.new(record).scope!
      scope.new(user, record).resolve if scope
    end

    def authorize(user, record, query)
      policy!(user, record)

      unless policy.public_send(query)
        raise Sand::NotAuthorizedError.new(query, record)
      end
    end

    def skip_sand_authorization
      authorized!
    end

    def skip_sand_scoping
      scoped!
    end

    private

    def authorized!
      env['sand.authorized'] = true
    end

    def scoped!
      env['sand.scoped'] = true
    end
  end
end
