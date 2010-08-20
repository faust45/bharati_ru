class HHash < HashWithIndifferentAccess

  def doc_id
    self['id']
  end

  def get(model)
    model.get(doc_id)
  end

  def method_missing(method, *args)
    self[method]
  end

end
