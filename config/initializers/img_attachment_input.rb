module SimpleForm
  module Inputs
    class ImgAttachmentInput < Base
      def input
        @builder.file_field("#{attribute_name}_file", input_html_options)
      end

      def components_list
        [ :label, :attachments, :input, :hint, :error ]
      end

      def attachments
        attach_content = ''
        img = object.send("#{attribute_name}")

        img.thumbs.each do |k, v|
          attach_content << template.image_tag(v['url'])
        end

        template.content_tag(:div, attach_content.html_safe, :id => 'attachments')
      end
    end
  end
end
