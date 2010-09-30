class Admin::AudiosController < AdminController

  def index
    @audios = Audio.all
  end

  def author
    @author = Author.get_doc!(params[:author_id])
    @audios = Audio.get_by_author(@author.id)

    render :action => :index
  end

  def new 
    audio = Audio.new(:source_file => params['file'])
    audio.save
    logger.info audio.inspect

    render :json => {'success' => true, 'doc' => audio} 
  end

  def upload_photo
    logger.debug(params.inspect)
    audio = Audio.get_doc!(params['track_id'])
    audio.photos_file = params['file']
    audio.save

    audio = Audio.get_doc!(audio.id)

    render :json => {'success' => true, 'doc' => audio} 
  end

  def replace_source
    is_need_update_info = params['need_update_info']
    is_need_update_info = is_need_update_info == 'true' ? true : false

    audio = Audio.get_doc!(params[:track_id])
    audio.source_replace(params['file'], is_need_update_info)

    audio = Audio.get_doc!(audio.id)
    render :json => {'success' => true, 'doc' => audio} 
  end

  def update
    @audio = Audio.get_doc!(params[:id])
    @audio.update_attributes(params[:track])

    render :json => "ok".to_json
  end

end
