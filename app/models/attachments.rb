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
      attr_accessor "#{attr_name}_doc" 

      callback_method = "save_#{attachment_collection_name.singularize}"
      define_model_callbacks callback_method, :only => :after

      define_method attr_name do
        collection = send(attachment_collection_name)
        collection.first
      end

      before_save do
        send("_run_#{callback_method}_callbacks") do
          file = send(file_source)

          unless file.blank?
            doc = store_class.create!(file, options)
            send("#{attr_name}_doc=", doc)

            collection = send(attachment_collection_name)
            collection << {:doc_id => doc.id, :file_name => doc.file_name}
          end
        end
      end
    end
  end

  module InstanceMethods
  end
end
