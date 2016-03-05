require 'spec_helper'
require 'support/rack_app'
require 'rack/test'

RSpec.describe "Sand in the context of a rack Application "do
  include Rack::Test::Methods
  include_examples "RackApplications"

  def app
    MyRackApp
  end
end
