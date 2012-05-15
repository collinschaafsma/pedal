module Pedal
  class Resource < Webmachine::Resource
    attr_reader :action

    def initialize
      @action = request.method.downcase.to_sym
    end

    def resource_exists?
      self.class.public_instance_methods.include?(action)
    end

    def content_types_provided
      [['text/html', action]]
    end

    def handle_exception(e)
      response.error = [e.message, e.backtrace].flatten.join("\n    ")
      Webmachine.render_error(500, request, response)
    end

    def allowed_methods
      ['GET', 'POST', 'PUT', 'DELETE']
    end

    def encodings_provided
      if Pedal::Application.config.gzip_response
        Logger.debug 'gzip response'
        {"gzip" => :encode_gzip, "identity" => :encode_identity}
      else
        {"identity" => :encode_identity }
      end
    end
  end
end
