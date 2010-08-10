module SimpleForm
  module Inputs
    class AttachmentInput < Base
      def input
        @builder.file_field(attribute_name, input_html_options)
      end

      def components_list
        [ :label, :attachments, :input, :hint, :error ]
      end

      def attachments
        attach_content = ''
        attachments = object.send("#{attribute_name}_attachments")

        if options[:img]
          attachments.each do |file|
            attach_url = object.attachment_url(file)
            del_url = template.send(:admin_contents_delete_file_path, object.id, :attach => file)

            attach_content << template.image_tag(attach_url)
            attach_content << template.link_to('del', del_url, :remote => true)
          end
        else
          attachments.each do |file|
            attach_url = object.attachment_url(file)
            del_url = template.send(:admin_contents_delete_file_path, object.id, :attach => file)

            attach_content << template.link_to(file, attach_url)
            attach_content << '&nbsp;'
            attach_content << template.link_to('del', del_url, :remote => true)
          end
        end


        template.content_tag(:div, attach_content.html_safe, :id => 'attachments')
      end
    end
  end
end

SimpleForm::Inputs::MappingInput.map_type(:attachment,  :to => :attachment)
