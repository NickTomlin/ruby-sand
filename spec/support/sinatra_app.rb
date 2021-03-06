require 'sinatra'
require 'sand'
require 'json'
require 'support/shared_application_code'

get '/' do
  'Index'
end

helpers Sand::Helpers
use Sand::Middleware

get '/users/:user_id/accounts' do
  user = User[params[:user_id]]
  accounts = policy_scope(user, Account)
  send :erb, accounts.map(&:to_hash).to_json
end

get '/verify_scoped/fail' do
  send :erb, Account.all.map(&:to_hash).to_json
end

get '/verify_scoped/succeed' do
  user = User.find('1')
  accounts = policy_scope(user, Account)
  send :erb, accounts.map(&:to_hash).to_json
end

get '/verify_scoped/pass' do
  skip_sand_scoping
  200
end

get '/verify_authorized/fail' do
  user = User.find('1')
  account = Account.first
  authorize(user, account, :will_fail_action)
  send :erb, account.to_json
end

get '/verify_authorized/success' do
  user = User.find('1')
  account = Account.first
  authorize(user, account, :will_succeed_action)
  send :erb, account.to_json
end
