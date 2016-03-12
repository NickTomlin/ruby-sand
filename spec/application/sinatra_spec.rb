require 'spec_helper'
require 'support/sinatra_app'
require 'rack/test'
require 'json'

RSpec.describe Sand::Helpers do
  include_examples 'RackApplications'

  def app
    Sinatra::Application
  end
end
