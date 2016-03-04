require 'rack'
require 'support/shared_application_code'

class SandApp
  def call(env)
    request = Rack::Response.new(env)
    # get params
    user = User.find(params[:user_id])
    accounts = env.policy_finder(user, Account)
    accounts_json = JSON.dump(accounts.map(&:to_hash))
  end
end

MyRackApp = Rack::Builder.new do
  use Sand::Middleware
  use SandApp
end
