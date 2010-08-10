SimpleForm.setup do |config|
  config.label_text = lambda { |label, required| "#{label}" }
end

module SimpleForm

  module Inputs
    class Base
      def label
        label_need_wrap = (options[:label_wrap].nil? ? true : options[:label_wrap])

        if label_need_wrap
          template.content_tag(:div, super)
        else
          super
        end
      end
    end
  end

end
