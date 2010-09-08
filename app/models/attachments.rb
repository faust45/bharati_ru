module Attachments
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    #Single attachment mount
    def has_attachment(attr_name, store_class, options = {}, &block)
      options[:owner_type] = self.class.to_s

      attachment_collection_name = "#{attr_name}_attachments"
      file_source = "#{attr_name}_file"

      property attachment_collection_name, [SingleAttachment], :default => []
      attr_accessor file_source
      attr_accessor "#{attr_name}_doc"

      callback_create_method = "create_#{attachment_collection_name.singularize}"
      callback_replace_method = "replace_#{attachment_collection_name.singularize}"
      define_model_callbacks callback_create_method,  :only => :after
      define_model_callbacks callback_replace_method, :only => :after

      define_method attr_name do
        collection = send(attachment_collection_name)
        collection.first
      end

      before_save do
        file = send(file_source)

        unless file.blank?
          unless send(attr_name).blank?
            #replace attachment
            send("_run_#{callback_replace_method}_callbacks") do
              doc = store_class.get(send(attr_name).doc_id)
              doc.replace(file)
              send("#{attr_name}_doc=", doc)
            end
          else
            #create new attachment
            send("_run_#{callback_create_method}_callbacks") do
              doc = store_class.create!(file, options)
              send("#{attr_name}_doc=", doc)

              collection = send(attachment_collection_name)
              collection << doc.to_item
            end
          end
        end
      end
    end

    def has_attachments(attr_name, store_class, options = {}, &block)
      attachment_collection_name = "#{attr_name}_attachments"
      file_source = "#{attr_name}_file"

      property attachment_collection_name, [SingleAttachment], :default => []
      attr_accessor file_source
      attr_accessor "#{attr_name}_doc" 

      #callback_create_method = "create_#{attachment_collection_name.singularize}"
      #callback_replace_method = "replace_#{attachment_collection_name.singularize}"
      #define_model_callbacks callback_create_method,  :only => :after
      #define_model_callbacks callback_replace_method, :only => :after

      define_method attr_name do
        send(attachment_collection_name)
      end

      before_save do
        file = send(file_source)

        unless file.blank?
          #create new attachment
          send("_run_#{callback_create_method}_callbacks") do
            doc = store_class.create!(file, options)
            send("#{attr_name}_doc=", doc)

            collection = send(attachment_collection_name)
            collection << {:doc_id => doc.id, :file_name => doc.file_name}
          end
        end
      end
    end

    def has_photo_attachment(attr_name, size)
      has_attachment(attr_name, PhotoThumbStore, {:size => size, :thumb_type => attr_name})
    end

  end

  module InstanceMethods
  end
end
