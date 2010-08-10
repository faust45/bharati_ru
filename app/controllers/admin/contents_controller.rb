class Admin::ContentsController < AdminController

  def new
    @content = model.new
  end

  def destroy
    content.destroy
  end

  def delete_file
    content.delete_attachment(params[:attach])
    content.save
  end

  def content
    @content ||= model.get(params[:id])
  end

  def form_adapter
    Object.const_get("#{model.to_s}FormAdapter").new(content)
  end

  def object_name
    model.to_s.downcase
  end

  helper_method :content, :form_adapter, :object_name

  protected
    def adapted_params
      @adapted_params ||= ContentParamsAdapter.new params[model_name]
    end

    def model
      Content
    end

    def model_name
      model.to_s.downcase
    end

end
