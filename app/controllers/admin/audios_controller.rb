class Admin::AudiosController < Admin::ContentsController
  skip_before_filter :verify_authenticity_token
  free_actions :upload, :replace_source, :upload_photo

  def index
    @audios = Audio.all
  end

  def author
    @author = Author.get!(params[:author_id])
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

    audio = Audio.get(audio.id)

    render :json => {'success' => true, 'doc' => audio} 
  end

  def replace_source
    is_need_update_info = params['need_update_info']
    is_need_update_info = is_need_update_info == 'true' ? true : false

    logger.debug('original_filename')
    logger.debug(params['file'].original_filename)
    audio = Audio.get_doc!(params[:track_id])
    audio.source_replace(params['file'], is_need_update_info)

    audio = Audio.get_doc!(audio.id)
    render :json => {'success' => true, 'doc' => audio} 
  end

  def update
    content.update_attributes(adapted_params)
    redirect_to admin_audios_path
  end

  private 
    def model
      Audio
    end

end
