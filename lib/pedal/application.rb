module Pedal
  class Application < Webmachine::Application
    def environment
      ENV["RACK_ENV"].downcase ||= 'development'
    end

    def development?; environment == 'development'; end
    def production?;  environment == 'production';  end
    def test?;        environment == 'test';        end

    def root
      ENV["PEDAL_ROOT"]
    end

    class << self
      def environment
        ENV["RACK_ENV"].downcase ||= 'development'
      end

      def development?; environment == 'development'; end
      def production?;  environment == 'production';  end
      def test?;        environment == 'test';        end

      def root
        ENV["PEDAL_ROOT"]
      end

      def config
        @@config ||= Pedal::Configuration.new
      end

      def configure
        yield config
      end
    end

  end
end
