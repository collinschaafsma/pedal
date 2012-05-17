require "blankslate"

module Pedal
  module Utils
    class NothingExecutedError < Exception; end

    # See: https://gist.github.com/fae73df4b7063ab43c10
    # By: rogerbraun
    class BlockSwitcher < BlankSlate

      def initialize(x, args)
        @x = x
        @args = args
        @ret = nil
        @called = false
        @callees = []
      end

      def ensure
        raise NothingExecutedError, "Nothing got executed! Expected one of #{@callees.inspect}, but only got #{@x}" if not @called
      end

      def method_missing(method,*args, &block)
        if (method.downcase == @x.to_sym.downcase or method == :always) or (@called == false and method == :else) then
          @called = true
          if args.size > 0 then
            @ret = args.first.call(*@args)
          else
            @ret = block.call(*@args)
          end
        end
        # For error reporting
        @callees << method
        @callees.uniq!
        # Always return something meaningful
        @ret
      end
    end

    private
    def it_to(x, *args)
      BlockSwitcher.new(x, args)
    end
  end
end
