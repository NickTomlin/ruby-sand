module Sand
  module Helpers
    def policy_scope(user, record)
      scope = PolicyFinder.new(record).scope!
      scope.new(user, record).resolve if scope
    end

    def authorize(user, record, query)
      policy!(user, record)

      unless policy.public_send(query)
        raise "You can't do that. This should be more informative"
      end
    end
  end
end
