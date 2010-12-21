class PhotosController < ApplicationController
  free_actions :index, :show, :author, :bhagavatam, :album

  def index
    @albums = PhotoAlbum.get_all
  end

  def album
    @album = PhotoAlbum.get_doc(params[:id])
    @photos = @album.photos
  end

end
