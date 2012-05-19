module Pedal
  class Request < Webmachine::Request
    # Check for X-HTTP-Method-Override header and change the request method
    def initialize(method, uri, headers, body)
      method = headers.has_key?('X-HTTP-Method-Override') ? headers.fetch('X-HTTP-Method-Override') : method
      super(method, uri, headers, body)
    end
  end
end
