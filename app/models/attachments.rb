module Attachments
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    #Single attachment mount
    def has_attachment(attr_name, store_class, options = {}, item_class = SingleAttachment, &block)
      options[:owner_type] = self.to_s
      options[:thumb] ||= {}
      options[:thumb][:owner_type] ||= self.to_s

      attachment_collection_name = "#{attr_name}_attachments"
      file_source  = "#{attr_name}_file"
      file_options = "#{attr_name}_options"

      property attachment_collection_name, [item_class], :default => []
      attr_accessor file_source
      attr_accessor "#{attr_name}_doc"
      attr_accessor file_options

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
        file_opts = send(file_options) || {}

        unless file.blank?
          unless send(attr_name).blank?
            #replace attachment
            send("_run_#{callback_replace_method}_callbacks") do
              doc = store_class.get(send(attr_name).doc_id)
              doc.replace(file, options.merge(file_opts))
              send("#{attr_name}_doc=", doc)

              collection = send(attachment_collection_name)
              collection.replace([])
              collection << doc.to_item
            end
          else
            #create new attachment
            send("_run_#{callback_create_method}_callbacks") do
              doc = store_class.create!(file, options.merge(file_opts))
              send("#{attr_name}_doc=", doc)

              collection = send(attachment_collection_name)
              collection << doc.to_item
            end
          end
        end
      end
    end

    def has_attachments(attr_name, store_class, options = {}, item_class = SingleAttachment, &block)
      options[:owner_type] = self.to_s
      options[:thumb] ||= {}
      options[:thumb][:owner_type] = self.to_s

      attachment_collection_name = "#{attr_name}_attachments"
      file_source = "#{attr_name}_file"

      property attachment_collection_name, [item_class], :default => []
      attr_accessor file_source
      attr_accessor "#{attr_name}_doc"

      callback_add_method = "add_#{attachment_collection_name.singularize}"
      callback_delete_method = "delete_#{attachment_collection_name.singularize}"
      define_model_callbacks callback_add_method,  :only => :after
      define_model_callbacks callback_delete_method, :only => :after

      define_method attr_name do
        send(attachment_collection_name)
      end

      define_method "#{attr_name}_delete" do |attach_id|
        collection = send(attachment_collection_name)
        el = collection.find{|a| a.doc_id == attach_id}

        if el
          send("_run_#{callback_delete_method}_callbacks") do
            attach = store_class.get(el.doc_id)
            attach.destroy
            collection.reject!{|a| a.doc_id == attach_id}
          end
        end
      end

      before_save do
        file = send(file_source)

        unless file.blank?
          #add attachment
          send("_run_#{callback_add_method}_callbacks") do
            doc = store_class.create!(file, options)
            send("#{attr_name}_doc=", doc)

            collection = send(attachment_collection_name)
            collection << doc.to_item
          end
        end
      end
    end

    def has_photo_attachment(attr_name, options = {})
      has_attachment(attr_name, PhotoStore, options)
    end

    def has_photo_attachments(attr_name, options = {})
      has_attachments(attr_name, PhotoStore, options)
    end

    def has_thumb_attachment(attr_name, size)
      has_attachment(attr_name, PhotoThumbStore, {:size => size, :thumb_type => attr_name})
    end

    def has_big_thumb_attachment(attr_name, size)
      has_attachment(attr_name, BigPhotoThumbStore, {:size => size, :thumb_type => attr_name})
    end

  end

  module InstanceMethods
  end
end
