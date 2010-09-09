class Admin::AuthorsController < AdminController
  #uses_tiny_mce 

  def autocomplete
    authors = Author.search(params[:q])
    authors.map!{|t| "#{t['fields']['default']}|#{t['id']}"}
    
    render :json => authors.join("\n").to_json
  end

  def index
    @authors = Author.all
  end

  def new
    @author = Author.new
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

  def edit
    @author = Author.get(params[:id])
  end

  def update
    @author = Author.get(params[:id])

    @author.update_attributes(params[:author])
    redirect_to admin_authors_path
  end

  def destroy 
    @author = Author.get(params[:id])
    @author.delete
  end

  def delete_file
    @author = Author.get(params[:id])
    @author.delete_attachment(params[:attach])
    @author.save
  end

end
