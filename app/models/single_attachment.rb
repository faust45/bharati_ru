class SingleAttachment < HHash

  def initialize(params = {})
    super(params)
    self['url'] = url
  end

  def url
    "http://93.94.152.87:82/#{FileStore.database.name}/#{doc_id}/#{file_name}"
  end

end
