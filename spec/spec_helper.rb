ENV["PEDAL_ROOT"] ||= File.expand_path(File.dirname(__FILE__))
$LOAD_PATH << File.expand_path("..", __FILE__)
$LOAD_PATH << File.expand_path("../../lib", __FILE__)

require 'rubygems'
require 'pedal'
require 'rspec'

RSpec.configure do |config|
  config.mock_with :rspec
end
