module Pedal
  class Configuration
    attr_accessor :templates_root, :gzip_response, :public_root,
      :templates_extension, :template_engine

    def initialize
      self.templates_root      = 'templates'
      self.public_root         = 'public'
      self.gzip_response       = false
      self.templates_extension = 'html'
      self.template_engine     = :handlebars
    end
  end
end
