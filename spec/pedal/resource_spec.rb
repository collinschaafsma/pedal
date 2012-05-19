require 'spec_helper'

describe Pedal::Resource do
  let(:dispatcher) { Pedal.application.dispatcher }

  let(:resource) do
    TestsResource = Class.new(Pedal::Resource) do
      def index
        respond_to do |format|
          format.json { { index: 'JSON' } }
          format.html { "<p>index html</p>" }
        end
      end
      def show;   "show action";   end
      def new;    "new action";    end
      def edit;   "edit action";   end
      def create; end
      def update; end
      def destroy; true; end
      def create_path; "/tests/new-test"; end
    end
  end

  before :all do
    dispatcher.add_route ['tests', '*'], resource
  end

  describe "GET - HTML /tests resource" do
    response = Pedal::Response.new
    request  = Pedal::Request.new("GET",
                    URI.parse("http://localhost:8080/tests"),
                    Webmachine::Headers["accept" => "*/*"], "")

    it "should call the index method" do
      dispatcher.dispatch(request, response)
      response.body.should == "<p>index html</p>"
    end
  end

  describe "GET - JSON /tests resource" do
    response = Pedal::Response.new
    request  = Pedal::Request.new("GET",
                    URI.parse("http://localhost:8080/tests"),
                    Webmachine::Headers["accept" => "application/json"], "")

    it "should call the index method" do
      dispatcher.dispatch(request, response)
      response.body.should == '{"index":"JSON"}'
    end
  end

  describe "GET - HTML /tests/my-test resource" do
    response = Pedal::Response.new
    request  = Pedal::Request.new("GET",
                    URI.parse("http://localhost:8080/tests/my-test"),
                    Webmachine::Headers["accept" => "*/*"], "")

    it "should call the show method" do
      dispatcher.dispatch(request, response)
      response.body.should == "show action"
    end
  end

  describe "GET - HTML /tests/new" do
    response = Pedal::Response.new
    request  = Pedal::Request.new("GET",
                    URI.parse("http://localhost:8080/tests/new"),
                    Webmachine::Headers["accept" => "*/*"], "")

    it "should call the new method" do
      dispatcher.dispatch(request, response)
      response.body.should == "new action"
    end
  end

  describe "GET - HTML /tests/my-test/edit" do
    response = Pedal::Response.new
    request  = Pedal::Request.new("GET",
                    URI.parse("http://localhost:8080/tests/my-test/edit"),
                    Webmachine::Headers["accept" => "*/*"], "")

    it "should call the edit method" do
      dispatcher.dispatch(request, response)
      response.body.should == "edit action"
    end
  end

  describe "POST - HTML /tests" do
    response = Pedal::Response.new
    request  = Pedal::Request.new("POST",
                    URI.parse("http://localhost:8080/tests"),
                    Webmachine::Headers["Content-Type" => "application/x-www-form-urlencoded"],
                    "name=new-test")

    it "should call the create method" do
      dispatcher.dispatch(request, response)
      response.code.should == 201
    end
  end

  describe "PUT - HTML /tests/my-test" do
    response = Pedal::Response.new
    request  = Pedal::Request.new("PUT",
                    URI.parse("http://localhost:8080/tests/my-test"),
                    Webmachine::Headers["Content-Type" => "application/x-www-form-urlencoded"],
                    "name=newer-test")

    it "should call the update method" do
      dispatcher.dispatch(request, response)
      response.code.should == 204
    end
  end

  describe "POST _method=PUT - HTML /tests/my-test" do
    response = Pedal::Response.new
    request  = Pedal::Request.new("POST",
                    URI.parse("http://localhost:8080/tests/my-test"),
                    Webmachine::Headers[
                      "Content-Type" => "application/x-www-form-urlencoded",
                      "X-HTTP-Method-Override" => "PUT"
                    ],
                    "name=newer-test")

    it "should call the update method" do
      dispatcher.dispatch(request, response)
      response.code.should == 204
    end
  end

  describe "DELETE - HTML /tests/my-test" do
    response = Pedal::Response.new
    request  = Pedal::Request.new("DELETE",
                    URI.parse("http://localhost:8080/tests/my-test"),
                    Webmachine::Headers["accept" => "*/*"], "")

    it "should call the destroy method" do
      dispatcher.dispatch(request, response)
      response.code.should == 204
    end
  end

  describe "POST _method=DELETE - HTML /tests/my-test" do
    response = Pedal::Response.new
    request  = Pedal::Request.new("POST",
                    URI.parse("http://localhost:8080/tests/my-test"),
                    Webmachine::Headers[
                      "accept" => "*/*",
                      "X-HTTP-Method-Override" => "DELETE"], "")

    it "should call the destroy method" do
      dispatcher.dispatch(request, response)
      response.code.should == 204
    end
  end
end
