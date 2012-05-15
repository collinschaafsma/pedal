require 'pedal/version'
require 'pedal/logger'
require 'pedal/errors'
require 'webmachine'
require 'webmachine/adapter'
require 'webmachine/adapters/rack'

module Pedal
  autoload :Application,   "pedal/application"
  autoload :Resource,      "pedal/resource"
  autoload :Representer,   "pedal/representer"
  autoload :Configuration, "pedal/configuration"
end
