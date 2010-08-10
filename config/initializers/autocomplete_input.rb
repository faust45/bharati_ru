module SimpleForm
  module Inputs
    class AutocompleteInput < StringInput

      def input
        hidden_attribute_name = "#{attribute_name}_id"
        options_for_hidden = {:name => "#{object_name}[#{attribute_name}]" }

        @builder.hidden_field(hidden_attribute_name, options_for_hidden) +
        @builder.text_field("#{attribute_name}_value", input_html_options)
      end

      def input_html_options
        url = template.send("#{attribute_name}_autocomplete_path")
        input_options = super
        input_options[:name] = "#{attribute_name}_autocomplete"
        input_options['data-url'] = url

        input_options
      end

    protected

      def limit
        column && column.limit
      end
    end
  end
end

SimpleForm::Inputs::MappingInput.map_type(:autocomplete,  :to => :autocomplete)
