class Admin::SeosController < AdminController

  def create
    @seo = Seo.new(params[:seo])
    @seo.id = request.referrer

    @seo.save
    redirect_to @seo.id
  end

  def update
    @seo = Seo.get_doc!(params[:seo_id])
    @seo.update_attributes(params[:seo])

    redirect_to @seo.id
  end

  def destroy 
    @seo = Seo.get_doc!(params[:seo_id])
    page = @seo.id
    @seo.destroy

    redirect_to page
  end

end
