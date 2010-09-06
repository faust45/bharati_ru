class FormAdapter

  class <<self
    def model_name
      @_model_name ||= ActiveModel::Name.new(model)
    end
  end

  def method_missing(method, *args)
    content.send(method, *args)
  end

  def respond_to?(method)
    super(method) || content.respond_to?(method)
  end

end
