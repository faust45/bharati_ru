class HHash < HashWithIndifferentAccess

  def get(model)
    model.get(doc_id)
  end

  #def inspect
  #  "doc_id: %s" % [doc_id]
  #end

  def method_missing(method, *args)
    self[method]
  end

end
