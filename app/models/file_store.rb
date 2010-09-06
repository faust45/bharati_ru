class FileStore < BaseModel
  use_db 'file_store'

  attr_accessor :file

  property :file_name
  property :upload_at, Time

  class FileSaveIsFail < Exception; end

  before_save :assign_meta_info
  after_save  :put_attachment_directly

  def self.create(file, options = {})
    super({:file => file})
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
      update_attributes(:file => new_file)
    end
  end

  private
    #Can be implement by concret class
    def assign_meta_info
      self.file_name = prepare_file_name
    end

    def put_attachment_directly
      options_for_attachment = {}
      assign_content_type(options_for_attachment)

      put_attachment(self.file_name, file.read, options_for_attachment)
    end

    def prepare_file_name
      Russian::translit(file.original_filename)
    end
  
    def assign_content_type(options)
      options[:content_type] ||= MIME::Types.type_for(file.original_filename).last.content_type
    end
end
