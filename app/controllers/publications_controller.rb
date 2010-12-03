class PublicationsController < ApplicationController
  free_actions :index, :show, :author, :bhagavatam, :album

  def index
    @acharya = Author.get_acharya_lib
    @authors = Author.get_authors_lib

    @publications = Publication.paginate(:get_all, :page => params[:page])

    @classic = AlbumPublication.get_classic
    @vaishnava = AlbumPublication.get_vaishnava
  end

  def album
    @acharya = Author.get_acharya_lib
    @authors = Author.get_authors_lib

    @classic = AlbumPublication.get_classic
    @vaishnava = AlbumPublication.get_vaishnava

    @album = AlbumPublication.get_doc!(params[:album_id])
    @publications = @album.get_publications

    render :index
  end

  def author
    @acharya = Author.get_acharya_lib
    @authors = Author.get_authors_lib

    @author = Author.get_doc!(params[:author_id])
    @books  = @author.get_books
    @articles = @author.get_articles
  end

  def bhagavatam

  end

  def show
    @publication = Publication.get_doc!(params[:id])
  end

  def block_title 
    'Публикации'
  end
  helper_method :block_title 

end
