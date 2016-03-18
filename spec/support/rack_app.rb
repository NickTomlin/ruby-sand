require 'rack'
require 'json'
require 'support/shared_application_code'

class SandApp # rubocop:disable
  def json_response(data)
    [200, {}, JSON.dump(data)]
  end

  def call(env)
    request = Rack::Request.new(env)

    case request.path_info
    when %r{/accounts$}
      id = /\d/.match(request.path_info)[0]
      user = User[id]
      accounts = env['sand'].policy_scope(user, Account)
      json_response(accounts.map(&:to_hash))
    when %r{/verify_scoped/failure}
      [200, {}, [1, 2, 3]]
    when %r{/verify_scoped/succeed}
      accounts = env['sand'].policy_scope(user, Account)
      json_response(accounts.map(&:to_hash))
    when %r{/verify_scoped/pass}
      env['sand'].skip_sand_scoping
      [200, {}, ['yay']]
    when %r{/verify_authorized/fail}
      user = User.find('1')
      account = Account.first
      env['sand'].authorize(user, account, :will_fail_action)
      [200, {}, ['yay']]
    when %r{/verify_authorized/success}
      user = User.find('1')
      account = Account.first
      env['sand'].authorize(user, account, :will_succeed_action)
      [200, {}, ['yay']]
    else
      [404, {}, []]
    end
  end
end

MyRackApp = Rack::Builder.new do
  use Sand::Middleware

  run SandApp.new
end
