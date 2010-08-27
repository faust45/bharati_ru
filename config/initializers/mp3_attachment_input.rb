module SimpleForm
  module Inputs
    class Mp3AttachmentInput < Base
      delegate :content_tag, :link_to, :image_tag, :check_box_tag, :to => :template

      def input
        content_tag(:div, :class => 'hide') do
          #image_tag("/images/ajax-loader.gif", :id => "img_loader", :class => "hide")
        end
      end

      def components_list
        [ :label, :attachments, :hint, :error ]
      end

      def attachments
        content = ''.html_safe
        attachment = object.send("#{attribute_name}")

        content.safe_concat link_to(attachment.file_name, attachment.url, :class => 'download')
        content.safe_concat '&nbsp&nbsp'
        content.safe_concat link_to(image_tag('/images/cancel.png'), '', :class => 'delete')
        content.safe_concat '&nbsp&nbsp'
        content.safe_concat @builder.file_field("#{attribute_name}_file", input_html_options)

        content_tag(:div, content, :id => 'attachments')
      end

      def input_html_options
        {'data-replace-url' => template.admin_audio_replace_source_path}
      end
    end
  end
end

