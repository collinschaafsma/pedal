module Pedal
  class Presenter
    attr_reader :subject

    def initialize(subject)
      @subject = subject
    end

    # Proxy to the Builder, adds itself to the scope
    # so we can access the @subject
    def build(&block)
      Pedal::Builder.build(scope: self, &block)
    end
  end
end
