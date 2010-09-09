module SimpleForm
  module Inputs
    class ImgAttachmentsInput < Base
      def input
        @builder.file_field("#{attribute_name}_file", input_html_options)
      end

      def components_list
        [ :label, :attachments, :input, :hint, :error ]
      end

      def attachments
        attach_content = ''
        imgs = object.send("#{attribute_name}")

        imgs.each do |img|
          v = img.thumbs['small']
          attach_content << template.image_tag(v['url'])
        end

        template.content_tag(:div, attach_content.html_safe, :id => 'attachments')
      end
    end
  end
end
