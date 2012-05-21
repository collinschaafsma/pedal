require 'spec_helper'

describe Pedal::Renderers do
  let(:dispatcher) { Pedal.application.dispatcher }

  let(:resource) do
    WelcomeResource = Class.new(Pedal::Resource) do
      def index
        respond_to do |format|
          format.json { { index: 'JSON' } }
          format.html { { foo: 'testing', bar: '123' } }
        end
      end
    end
  end

  before { dispatcher.reset }

  describe "handlebars renderer" do
    response = Pedal::Response.new
    request  = Pedal::Request.new("GET",
                    URI.parse("http://localhost:8080/"),
                    Webmachine::Headers["accept" => "*/*"], "")

    it "should parse the hash, render the html within a layout and pull in a partial" do
      dispatcher.add_route ['*'], resource
      dispatcher.dispatch request, response
      response.body.should == "<body>testing, 123\n\n</body>\n"
    end
  end
end
