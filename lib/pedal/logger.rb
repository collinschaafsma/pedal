require 'logger'

module Pedal
  # Convenience method for the Logger
  def self.logger; Logger; end

  module Logger
    @logger = ::Logger.new STDERR
    module_function

    def logger=(logger)
      @logger = logger
    end

    def logger
      @logger
    end

    def debug(msg); @logger.debug(msg); end
    def info(msg);  @logger.info(msg);  end
    def warn(msg);  @logger.warn(msg);  end
    def error(msg); @logger.error(msg); end
  end
end
