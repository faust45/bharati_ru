class SingleAttachment < HHash

  def initialize(params = {})
    super(params)
  end

  def url
    "http://192.168.1.100:5984/#{FileStore.database.name}/#{doc_id}/#{file_name}"
  end

end
