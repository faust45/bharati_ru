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
        attachments = object.send("#{attribute_name}")

        attachments.each do |attach|
          del_url = template.send(:admin_contents_delete_file_path, object.id, :attach => attach.doc_id)

          attach_content << template.image_tag(attach.url)
          attach_content << template.link_to('del', del_url, :remote => true)
        end

        template.content_tag(:div, attach_content.html_safe, :id => 'attachments')
      end
    end
  end
end

SimpleForm::Inputs::MappingInput.map_type(:attachment,  :to => :attachment)
