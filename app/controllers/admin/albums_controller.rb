class Admin::AlbumsController < Admin::ContentsController
  protect_from_forgery :except => :destroy
  helper Admin::AlbumsHelper

  def index
    @albums = Album.all
  end

  def new
    @album = Album.new
  end

  def create
    @album = Album.new(params[:album])
    @album.save

    flash[:notice] = 'Album created success!'
    redirect_to admin_albums_path
  end

  def edit
  end

  def update
    album.update_attributes(params[:album])
    redirect_to admin_albums_path
  end

  def destroy
    album.destroy
    redirect_to admin_albums_path
  end

  def album
    @album ||= Album.get_doc!(params[:album_id])
  end

  def form_adapter
    @form_adapter ||= AlbumFormAdapter.new(album)
  end

  def autocomplete
    albums = Album.search(params[:q])
    albums.map!{|t| "#{t['fields']['default']}|#{t['id']}"}

    render :json => albums.join("\n").to_json
  end

  helper_method :album

  def add_track
    audio = Audio.get_doc!(params[:track_id])
    album << audio

    render :json => 'ok'
  end

  def drop_track
    audio = Audio.get_doc!(params[:track_id])
    album >> audio

    render :json => 'ok'
  end

end
