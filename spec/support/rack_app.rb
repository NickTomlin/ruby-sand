require 'rack'
require 'support/shared_application_code'

class SandApp
  def call(env)
    request = Rack::Request.new(env)


    user = User.find(request.params[:user_id])
    accounts = env.policy_finder(user, Account)

    [200, {}, [JSON.dump(accounts.map(&:to_hash))]]
  end
end

MyRackApp = Rack::Builder.new do
  use Sand::Middleware
  use SandApp

  run SandApp
end
