class PhotosController < ApplicationController
  free_actions :index, :show, :author, :bhagavatam, :album

  def index
    @sections_math = PhotoSection.get_math
    @sections_bs   = PhotoSection.get_bs

    unless params[:section_id].blank?
      @section = PhotoSection.get_doc(params[:section_id])
    end

    if @section
      @albums = PhotoAlbum.get_all_docs(@section.albums)
    else
      @albums = PhotoAlbum.get_all
    end
  end

  def album
    @album = PhotoAlbum.get_doc(params[:id])
    @photos = @album.photos
  end

end
