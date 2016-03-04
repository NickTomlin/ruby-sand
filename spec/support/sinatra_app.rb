require 'sinatra'
require 'sand'
require 'json'
require 'support/shared_application_code'

get '/' do
  'Index'
end

helpers Sand::Helpers

get '/users/:user_id/accounts' do
  user = User.find(params[:user_id])
  accounts = policy_scope(user, Account)
  send :erb, accounts.map(&:to_hash).to_json
end
