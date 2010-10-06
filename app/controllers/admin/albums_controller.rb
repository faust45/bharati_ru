class Admin::AlbumsController < Admin::ContentsController
  protect_from_forgery :except => :destroy
  helper Admin::AlbumsHelper

  def index
    @albums = Album.all
  end

  def new
    @album = Album.new
  end

  def upload_cover
    album = Album.get_doc!(params[:id])

    album.cover_file = params[:file]
    album.save
    album = Album.get_doc!(album.id)

    logger.debug('album.inspect')
    logger.debug(album.inspect)
    render :json => {'success' => true, 'img' => album.cover_attachments} 
  end

  def create
    @album = Album.new(params[:album])
    @album.save

    flash[:notice] = 'Album created success!'
    redirect_to admin_albums_path
  end

  def update
    album = Album.get_doc!(params['id'])
    album.update_attributes(params['album'])

    render :json => {:doc => album}
  end

  def destroy
    album.destroy
    redirect_to admin_albums_path
  end

  def album
    @album ||= Album.get_doc!(params[:album_id])
  end
  helper_method :album

  def autocomplete
    albums = Album.search(params[:q])
    albums.map!{|t| "#{t['fields']['default']}|#{t['id']}"}

    render :json => albums.join("\n").to_json
  end

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
