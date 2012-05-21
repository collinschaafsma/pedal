module Pedal
  module Renderers
    autoload :Tilt,         'pedal/renderers/tilt'
    autoload :Handlebars,   'pedal/renderers/handlebars'

    def render_html(presentation, template)
      template = expand_template(template)

      if File.exists? template
        if Pedal::Application.config.template_engine == :handlebars
          Pedal::Renderers::Handlebars.new(presentation, template).render
        else
          p template
          Pedal::Renderers::Tilt.new(presentation, template).render
        end
      else
        presentation.to_s
      end
    end

    def render_json(presentation, template = nil)
      # MultiJson will hunt for the fastest JSON parser you got.
      # If you want to make life easier on MultiJson add oj to your Gemfile
      # it's very fast!
      json = MultiJson.dump(presentation) unless presentation.is_a?(String)
      json ? json : presentation
    end

    def render_xml(presentation, template = nil)

    end

    def render_text(presentation, template = nil)

    end

    def render_atom_xml(presentation, template = nil)

    end

    def render_rss_xml(presentation, template = nil)

    end

    private
    def expand_template(template)
      ::File.join(Pedal::Application.root,
                  Pedal::Application.config.templates_root,
                  "#{template.to_s}.#{Pedal::Application.config.templates_extension}")
    end
  end
end
