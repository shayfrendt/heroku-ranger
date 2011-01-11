require File.expand_path("../../init", __FILE__)
require 'rspec'
require 'mocha'
require 'webmock/rspec'

Dir[File.expand_path("support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.color_enabled = true
  config.mock_with :mocha

  config.formatter = :progress
  config.color_enabled = true
  config.filter_run :focused => true
  config.run_all_when_everything_filtered = true
  config.alias_example_to :fit, :focused => true
  config.alias_example_to :they
end

include WebMock::API

def stub_api_request(method, path)
  stub_request(method, "https://rangerapp.com/api/v1/#{path}")
end
  
def prepare_command(klass)
  command = klass.new(['--app', 'myapp'])
  command.stubs(:args).returns([])
  command.stubs(:display)
  command.stubs(:heroku)
  # command.stubs(:heroku).returns(mock('heroku client', :host => 'heroku.com'))
  command.stubs(:extract_app).returns('myapp')
  command
end
