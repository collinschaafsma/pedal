module Pedal
  class Configuration
    attr_accessor :templates_root, :gzip_response, :public_root

    def initialize
      self.templates_root = 'templates'
      self.public_root    = 'public'
      self.gzip_response  = false
    end
  end
end
