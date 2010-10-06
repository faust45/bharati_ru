class Admin::AuthorsController < AdminController

  def autocomplete
    authors = Author.search(params[:q])
    authors.map!{|t| "#{t['fields']['default']}|#{t['id']}"}
    
    render :json => authors.join("\n").to_json
  end

  def index
    @authors = Author.all
  end

  def destroy
    @author = Author.get_doc!(params[:id])
    @author.destroy

    render :json => "ok".to_json
  end

  def new
    @author = Author.create(params[:author])

    render :json => {:doc => @author}
  end

  def create
    @author = Author.new(params[:author])

    if @author.save
      flash[:notice] = 'Author created succes!'
      redirect_to admin_authors_path
    else
      flash[:notice] = 'Author created is fail!'
      render :action => :new
    end
  end

  def update
    @author = Author.get_doc!(params[:id])

    @author.update_attributes(params[:author])

    render :json => "ok".to_json
  end

  def upload_photo
    @author = Author.get_doc!(params[:id])
    @author.main_photo_file = params[:file]
    @author.save

    @author = Author.get_doc!(@author.id)
    render :json => {'success' => true, 'img' => @author.main_photo_attachments} 
  end

  def delete_file
    @author = Author.get(params[:id])
    @author.delete_attachment(params[:attach])
    @author.save
  end

end
