require 'support/rack_app'

RSpec.describe Sand::Middleware do
  include Rack::Test::Methods

  def app
    MyRackApp
  end
end
