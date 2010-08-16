class SingleAttachment < HHash
  FILE_STORE = 'file_store'

  def url
    "http://93.94.152.87:82/#{FILE_STORE}/#{doc_id}/#{file_name}"
  end

end
