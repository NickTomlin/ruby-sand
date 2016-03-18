RSpec.shared_examples 'RackApplications' do
  include Rack::Test::Methods

  before(:each) do
    # poor man's database cleaner
    User.all.each(&:delete)
    Account.all.each(&:delete)
  end

  let!(:user) { User.create(name: 'Normal User', admin: false) }
  let!(:admin_user) { User.create(name: 'Admin User', admin: true) }

  describe 'finding resources via policy_scope' do
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

  describe 'verify_scoped' do
    it 'raises a Sand::NotAuthorizedError if policy has not been authorized' do
      expect do
        get '/verify_scoped/fail'
      end.to raise_error Sand::AuthorizationNotPerformed
    end

    it 'does nothing if resource has been authorized' do
      get '/verify_scoped/succeed'

      expect(last_response).to be_ok
    end

    it 'allows users to skip authorization' do
      get '/verify_scoped/pass'

      expect(last_response).to be_ok
    end
  end

  describe 'verify_authorized' do
    before { Account.create(title: 'Test') }
    it 'raises an error if resource has not been authorized' do
      expect do
        get '/verify_authorized/fail'
      end.to raise_error Sand::NotAuthorizedError
    end

    it 'does nothing if resource has been authorized' do
      get '/verify_authorized/success'
      expect(last_response).to be_ok
    end
  end
end
