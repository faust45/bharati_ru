class Admin::AudiosController < Admin::ContentsController
  #uses_tiny_mce
  skip_before_filter :verify_authenticity_token
  free_actions :upload, :replace_source

  def index
    @audios = Audio.all
    logger.info 'in index cool'
  end

  def upload
    audio = Audio.new(:source_file => params['Filedata'])
    audio.save
    logger.info audio.inspect
    render :json => {:redirect_to => edit_admin_audio_path(audio)} 
  end

  def replace_source
    is_need_update_info = params['need_update_info']
    is_need_update_info = is_need_update_info == 'true' ? true : false

    audio = Audio.get(params[:id])
    audio.source_replace(params['Filedata'], is_need_update_info)

    render :json => audio.source 
  end

  def create
    begin
      adapted_params[:uploader] = current_user

      @content = Audio.new(adapted_params)
      @content.save

      adapted_params.albums.each do |album|
        album << @content
      end

      flash[:notice] = 'Audio created success!'
      redirect_to admin_audios_path

    rescue => ex
      flash[:notice] = 'Audio created is fail!'
      render :action => :new
    end
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
