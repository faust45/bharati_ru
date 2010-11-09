class PublicationsController < ApplicationController
  free_actions :index, :show, :author, :bhagavatam

  def index
    @acharya = Author.get_acharya_lib
    @authors = Author.get_authors_lib

    @publications = Publication.paginate(:get_all, :page => params[:page])
  end

  def author
    @acharya = Author.get_acharya_lib
    @authors = Author.get_authors_lib

    @author = Author.get_doc!(params[:author_id])
    @books  = @author.get_books
    @articles = @author.get_articles
  end

  def bhagavatam
    @acharya = Author.get_acharya_lib
    @authors = Author.get_authors_lib

    @publications = Publication.get_all_bhagavatam

    render :index
  end

  def show
    @publication = Publication.get_doc!(params[:id])
  end

  def block_title 
    'Публикации'
  end
  helper_method :block_title 

end
