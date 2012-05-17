require 'tilt'

module Pedal
  module Renderers
    class Tilt
      attr_reader :presentation, :template

      def initialize(presentation, template)
        @presentation = presentation
        @template     = template
      end

      def render
        template = ::Tilt.new(template)
        template.render(nil, presentation)
      end
    end
  end
end
