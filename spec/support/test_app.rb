require 'sinatra'
require 'sand'
require 'sequel'
require 'json'

DB = Sequel.sqlite

DB.create_table :users do
  primary_key :id
  String :name
  Boolean :admin
end

DB.create_table :accounts do
  primary_key :id
  String :title
end

DB.create_table :roles do
  Integer  'user_id'
  Integer  'account_id'
  String   'role'
end

class Account < Sequel::Model; end
class User < Sequel::Model; end
class Role < Sequel::Model
  many_to_one :user
  many_to_one :account
end

class AccountPolicy
  def initialize(user, record)
    @user = user
    @record = record
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return [] if user.nil?
      return scope.all if user.admin

      scope.join(:roles, account_id: :id).where(user_id: user.id)
    end
  end
end


get '/' do
  'Index'
end

helpers Sand::Helpers

get '/users/:user_id/accounts' do
  user = User.find(params[:user_id])
  accounts = policy_scope(user, Account)
  send :erb, accounts.map(&:to_hash).to_json
end
