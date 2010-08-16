class FileStore < BaseModel
  use_db 'file_store'

  attr_accessor :file_name

  class FileSaveIsFail < Exception; end

  def self.create(file, options = {})
    file_name = Russian::translit(file.original_filename)

    options_for_doc = {}
    if options[:type]
      options_for_doc[:type] = options[:type] 
    end

    options_for_attachment = {}
    if options[:content_type]
      options_for_attachment['Content-Type'] = options[:content_type]
    end

    doc = super(options_for_doc)
    doc.put_attachment(file_name, file.read, options_for_attachment)
    doc.file_name = file_name

    doc
  end

  def self.create!(file, options = {})
    doc = create(file, options)
    raise FileSaveIsFail if doc.new?

    doc
  end

end
