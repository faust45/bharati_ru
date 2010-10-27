class PublicationsController < ApplicationController
  free_actions :index

  def index
    @acharya = Author.get_acharya
    @authors = Author.get_authors

    @publications = Publication.paginate(:get_all, :page => params[:page])
  end

  def author
    @author = Author.get_doc!(params[:author_id])
    @publications = @author.paginate(:get_publications, :page => params[:page])
  end

  def show
    @publication = Publication.get_doc!(params[:id])
  end

end
