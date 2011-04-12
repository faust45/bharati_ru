class PublicationsController < ApplicationController
  free_actions :index, :show, :author, :bhagavatam, :album

  def index
    @acharya = Author.get_acharya_lib
    @authors = Author.get_authors_lib

    @publications = Publication.paginate(:get_all, :page => params[:page])

    @classic = AlbumPublication.get_classic
    @vaishnava = AlbumPublication.get_vaishnava

    @page_title = "Библиотека"
  end

  def album
    @acharya = Author.get_acharya_lib
    @authors = Author.get_authors_lib

    @classic = AlbumPublication.get_classic
    @vaishnava = AlbumPublication.get_vaishnava

    @album = AlbumPublication.get_doc!(params[:album_id])
    @publications = @album.get_publications

    @page_title = ["Библиотека", @album.to_s]
    render :index
  end

  def author
    @acharya = Author.get_acharya_lib
    @authors = Author.get_authors_lib

    @classic = AlbumPublication.get_classic
    @vaishnava = AlbumPublication.get_vaishnava

    @author = Author.get_doc!(params[:author_id])
    @books  = @author.get_books
    @articles = @author.get_articles

    @page_title = ["Библиотека", @author.to_s]
  end

  def bhagavatam

  end

  def show
    @publication = Publication.get_doc!(params[:id])

    @page_title = "#{@publication.author} - #{@publication}"
    @page_description = @publication.description 
  end

  def block_title 
    'Публикации'
  end
  helper_method :block_title 

end
