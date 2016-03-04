require 'spec_helper'
require 'support/sinatra_app'
require 'rack/test'
require 'json'

RSpec.describe Sand::Helpers do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let (:user) { User.create(name: "Normal User", admin: false) }
  let (:admin_user) { User.create(name: "Admin User", admin: true)  }
  describe "finding resources via policy_scope" do
    before(:each) do
      # poor man's database cleaner
      User.all.each(&:delete)
      Account.all.each(&:delete)
    end

    it "returns resources based on the Policy's Scope.resolve for 'admin' users" do
      3.times { |x| Account.create(title: "Account #{x}") }
      get "/users/#{admin_user.id}/accounts"

      expect(last_response).to be_ok
      body = JSON.parse(last_response.body)
      expect(body.size).to eq(3)
    end

    it "returns resources based on the Policy's Scope.resolve for 'normal'" do
      2.times do |x|
        account = Account.create(title: "Owned Account #{x}")
        Role.create(role: 'Normal', user_id: user.id, account_id: account.id)
      end

      Account.create(title: 'Not owned Account')

      get "/users/#{user.id}/accounts"

      expect(last_response).to be_ok
      body = JSON.parse(last_response.body)
      expect(body.size).to eq(2)
    end
  end
end
