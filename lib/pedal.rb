require 'pedal/version'
require 'pedal/logger'
require 'pedal/errors'
require 'pedal/utils'
require 'pedal/renderers'
require 'webmachine'
require 'webmachine/adapter'
require 'webmachine/adapters/rack'
require 'handlebars'
require 'multi_json'

module Pedal
  # Store the Handlebars::Context in a constant, otherwise
  # v8 will be initialized on every template render call and
  # will segfault under major load.
  HANDLEBARS = Handlebars::Context.new

  autoload :Application,   'pedal/application'
  autoload :Request,       'pedal/request'
  autoload :Response,      'pedal/response'
  autoload :Resource,      'pedal/resource'
  autoload :Presenter,     'pedal/presenter'
  autoload :Interface,     'pedal/interface'
  autoload :Configuration, 'pedal/configuration'
  autoload :Builder,       'pedal/builder'
end
