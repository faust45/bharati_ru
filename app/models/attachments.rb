module Attachments
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    #Single attachment mount
    def has_attachment(attr_name, store_class, options = {}, &block)
      attachment_collection_name = "#{attr_name}_attachments"
      file_source = "#{attr_name}_file"

      property attachment_collection_name, [SingleAttachment], :default => []
      attr_accessor file_source

      define_method attr_name do
        collection = send(attachment_collection_name)
        collection.first
      end

      after_create do
        file = send(file_source)

        unless file.blank?
          send("#{file_source}=", nil)
          doc = store_class.create!(file, options)

          collection = send(attachment_collection_name)
          collection << {:doc_id => doc.id, :file_name => doc.file_name}
        end

        if store_class.has_meta_info?
          attach = self.send(attr_name)
          doc = store_class.get(attach.doc_id)
          self.assign_meta_info(doc)
        end
      end
    end
  end

  module InstanceMethods
  end
end
