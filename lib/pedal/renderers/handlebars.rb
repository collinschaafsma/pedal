module Pedal
  module Renderers
    class Handlebars
      attr_reader :presentation, :template

      def initialize(presentation, template)
        @presentation = presentation
        @template     = template
      end

      def render
        # Get all the assigned variables from the presenter
        # including any default assignments in application_presenter
        # defaults = self.defaults if self.respond_to?(:defaults)
        # page_assignments = defaults.merge(self.send(action))

        Pedal::HANDLEBARS.partial_missing do |name|
          lambda do |this, context, options|
            Pedal::HANDLEBARS.compile(partial(name)).call(presentation)
          end
        end

        # Render the page
        rendered_page = Pedal::HANDLEBARS.compile(template_contents).call(presentation)

        # Render the layout
        full_presentation = presentation.has_key?(:layout) ? presentation[:layout].merge(:yield => rendered_page) : { :yield => rendered_page }
        Pedal::HANDLEBARS.compile(layout).call(full_presentation)
      end

      private
      def layout
        # Look and see if the default has been overrided in the presentation
        layout_file = presentation.has_key?(:layout) ? "/layouts/#{presentaton[:layout][:template]}" : "layouts/application.html"

        ::File.read(
          ::File.join(
            Pedal::Application.root,
            Pedal::Application.config.templates_root,
            layout_file.to_s
          )
        )
      end

      def template_contents
        ::File.read template
      end

      def template_directory
        ::File.path template
      end
    end
  end
end
