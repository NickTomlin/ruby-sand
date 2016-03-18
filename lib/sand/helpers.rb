module Sand
  module Helpers
    def policy_scope(user, record)
      scoped!
      scope = PolicyFinder.new(record).scope!
      scope.new(user, record).resolve if scope
    end

    def authorize(user, record, query)
      authorized!
      policy = Sand.policy!(user, record)
      unless policy.public_send(query)
        raise Sand::NotAuthorizedError.new(policy: policy, query: query, record: record) # rubocop:disable Metrics/LineLength, Style/RaiseArgs
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
