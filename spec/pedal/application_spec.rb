require 'spec_helper'

describe Pedal::Application do
  let(:app) { described_class }

  it "inherits from webmachine" do
    app.new.should be_kind_of(Webmachine::Application)
  end

  it "can be configured" do
    app.configure do |config|
      config.should be_kind_of(Pedal::Configuration)
    end
  end

  it "should default with handlebars as the template_engine" do
    app.config.template_engine.should equal(:handlebars)
  end

  it "should default with 'templates' as the template_root" do
    app.config.templates_root.should == 'templates'
  end

  it "should default with 'public' as the public_root" do
    app.config.public_root.should == 'public'
  end

  it "should default with 'flase' for gzip_response" do
    app.config.gzip_response.should equal(false)
  end

  it "should default with 'html' as the templates_extension" do
    app.config.templates_extension.should == 'html'
  end

end
