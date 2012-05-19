module Pedal
  class Resource < Webmachine::Resource
    include Utils
    include Renderers

    attr_reader :action

    def initialize
      @action = determine_action
    end

    def respond_to
      type = Webmachine::MediaType.parse(response.headers['Content-Type']).minor.gsub(/\+/, '_')
      presentation = yield it_to type
      self.send("render_#{type}", presentation, template_path)
    end

    def resource_exists?
      self.class.public_instance_methods.include?(action)
    end

    def content_types_provided
      [
        ['text/html',            action],
        ['application/json',     action],
        ['text/plain',           action],
        ['application/xml',      action],
        ['application/atom+xml', action],
        ['application/rss+xml',  action]
      ]
    end

    def content_types_accepted
      [
        ['application/x-www-form-urlencoded', action],
        ['application/octet-stream', action]
      ]
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
        {"gzip" => :encode_gzip, "identity" => :encode_identity}
      else
        {"identity" => :encode_identity }
      end
    end

    def post_is_create?
      true
    end

    def delete_resource
      if self.respond_to?(:destroy)
        self.send(:destroy)
      else
        false
      end
    end

    alias_method :destroy, :delete_resource

    private
    def determine_action
      http_method = request.method.downcase.to_sym

      case http_method
      when :get
        if edit?;  return :edit;   end
        if new?;   return :new;    end
        if show?;  return :show;   end
        if index?; return :index;  end
      when :put
        return :update
      when :post
        return :create
      when :delete
        return :delete_resource
      end
    end

    def edit?
      (request.path_tokens.length > 1 && request.path_tokens[1] == 'edit') ? true : false
    end

    def new?
      (request.path_tokens.length > 0 && request.path_tokens[0] == 'new') ? true : false
    end

    def show?
      ((request.path_tokens.length > 0) && (not new?) && (not edit?)) ? true : false
    end

    def index?
      request.path_tokens.length == 0 ? true : false
    end

    def template_path
      "#{self.class.name.gsub(/Resource/, '').gsub(/::/, '/').downcase}/#{action.to_s}"
    end
  end
end
