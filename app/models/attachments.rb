module Attachments
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def has_attachment(attr_name, options = {}, &block)
      attachment_collection_name = "#{attr_name}_attachments"
      file_source = "#{attr_name}_file"

      property attachment_collection_name, [SingleAttachment], :default => []
      attr_accessor file_source

      is_single_attachment = (attr_name.to_s.singularize == attr_name.to_s)
      if is_single_attachment
        define_method attr_name do
          collection = send(attachment_collection_name)
          collection.first
        end
      else
        define_method attr_name do
          collection = send(attachment_collection_name)
        end
      end

      before_save do
        p 'in before save'
        p self['_id']
        file = send(file_source)

        unless file.blank?
          doc = FileStore.create!(file, options)

          collection = send(attachment_collection_name)
          collection << {:doc_id => doc.id, :file_name => doc.file_name}

          if block_given?
            block.bind(self).call(file)
          end

          #self.save_without_callbacks
        end
      end
    end
  end

  module InstanceMethods
  end
end
