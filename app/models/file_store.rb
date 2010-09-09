class FileStore < BaseModel
  use_db 'file_store'

  attr_accessor :file

  property :file_name
  property :owner_type
  property :upload_at, Time

  define_model_callbacks :put_attachment_directly,  :only => [:before, :after]
  class FileSaveIsFail < Exception; end

  before_save :assign_meta_info
  after_save  :put_attachment_directly

  def self.create(file, options = {})
    super({:file => file}.merge(options))
  end

  def self.create!(file, options = {})
    doc = create(file, options)
    raise FileSaveIsFail if doc.new?

    doc
  end

  #replace only attachment
  def replace(new_file, options = {})
    unless self['_attachments'].blank?
      delete_attachment(self.file_name)
      update_attributes({:file => new_file}.merge(options))
    end
  end

  #Can be implement by concret class
  def to_item
    {:doc_id => id, :file_name => file_name}
  end

  private
    #Can be implement by concret class
    def assign_meta_info
      self.file_name = prepare_file_name
    end

    def put_attachment_directly
      _run_put_attachment_directly_callbacks do
        options_for_attachment = {}
        assign_content_type(options_for_attachment)

        put_attachment(self.file_name, file.read, options_for_attachment)
      end
    end

    def prepare_file_name
      Russian::translit(original_filename)
    end

    def assign_content_type(options)
      options[:content_type] ||= MIME::Types.type_for(original_filename).last.content_type
    end

    def original_filename
      if file.respond_to?(:original_filename)
        file.original_filename
      else
        File.basename(file.path)
      end
    end

end
