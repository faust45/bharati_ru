class Admin::AudiosController < Admin::ContentsController
  uses_tiny_mce

  def index
    @audios = Audio.all
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
