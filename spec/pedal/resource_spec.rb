require 'spec_helper'

describe Pedal::Resource do
  subject { Webmachine::Decision::FSM.new(resource, request, response) }
  let(:dispatcher) { Webmachine.application.dispatcher }
  let(:headers) { Webmachine::Headers.new }
  let(:body) { "" }
  let(:response) { Webmachine::Response.new }

  let(:resource) do
    TestsResource = Class.new(Pedal::Resource) do
      def index
        respond_to do |format|
          format.json { { index: 'JSON' } }
          format.html { "<p>index html</p>" }
        end
      end
      def show; "show action"; end
      def new;  "new action"; end
      def edit; "edit action"; end
      def create;end
      def update;end
      def delete;end
    end
  end

  describe "GET - HTML /tests resource" do
    let(:request) { Webmachine::Request.new("GET", URI.parse("http://localhost:8080/tests"), Webmachine::Headers["accept" => "*/*"], "") }

    it "should call the index method" do
      dispatcher.add_route ["tests"], resource
      dispatcher.dispatch(request, response)
      response.body.should == "<p>index html</p>"
    end
  end
end
