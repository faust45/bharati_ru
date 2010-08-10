class HHash < HashWithIndifferentAccess

  def method_missing(method, *args)
    self[method]
  end

end
