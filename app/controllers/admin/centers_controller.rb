class Admin::CentersController < AdminController

  def autocomplete
    centers = Center.search(params[:q])
    centers.map!{|t| "#{t['fields']['default']}|#{t['id']}"}
    
    render :json => centers.join("\n").to_json
  end

  def index
    @centers = Center.by_country.paginate(:page => params[:page], :per_page => 15)
  end

  def new
    @center = Center.new
  end

  def create
    @center = Center.create(params[:center])

    flash[:notice] = 'Center created success!'
    redirect_to admin_centers_path

    rescue => ex
      flash[:notice] = 'Center created is fail!'
      render :action => :new
  end

  def edit
  end

  def update
    center.update_attributes(params[:center])
    redirect_to admin_centers_path
  end

  def destroy 
    center.destroy
    redirect_to admin_centers_path
  end

  def delete_file
    center.delete_attachment(params[:attach])
    center.save
  end

  def center
    @center ||= Center.get(params[:id])
  end
  helper_method :center

end
