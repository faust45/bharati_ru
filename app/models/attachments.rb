module Attachments
  extend ActiveSupport::Concern

  included do
    define_model_callbacks :save_attachment, :only => :before
  end

  module ClassMethods
    def has_attachment(attr_name)
      attachment_collection_name = "#{attr_name}_attachments"

      property attachment_collection_name, [], :default => []
      attr_accessor attr_name

      before_save do
        @file = send(attr_name)
        unless @file.blank?
          save_attachment(attr_name) 
        end
      end

      after_save do
        @file = send(attr_name)
        unless @file.blank?
          directly_put_attachment
        end
      end
    end
  end

  module InstanceMethods
    def attachments
      if self[:_attachments]
        self[:_attachments].keys
      else
        []
      end
    end

    def save_attachment(attr_name)
      @options_for_attachment = {}
      _run_save_attachment_callbacks do
        @options_for_attachment['content-type'] = @content_type
        attachment_collection_name = "#{attr_name}_attachments"
        collection = send(attachment_collection_name)
        @file_name = Russian::translit(@file.original_filename)
        collection << @file_name
      end
    end

    def directly_put_attachment
      @file_name = Russian::translit(@file.original_filename)
      put_attachment(@file_name, @file.read, @options_for_attachment)
    end

    def attachment_url(name)
      "http://93.94.152.87:82/#{database.name}/#{self.id}/#{name}"
    end
  end
end
