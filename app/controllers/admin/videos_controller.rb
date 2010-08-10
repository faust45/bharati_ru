class Admin::VideosController < Admin::ContentsController
  uses_tiny_mce 

  def index
    @videos = Video.all
  end

  def create
    begin
      adapted_params[:uploader] = current_user

      @content = Video.new(adapted_params)
      @content.save

      flash[:notice] = 'Video created succes!'
      redirect_to admin_videos_path

    rescue => ex
      flash[:notice] = 'Video created is fail!'
      render :action => :new
    end
  end

  def update
    content.update_attributes(adapted_params)
    redirect_to admin_videos_path
  end

  private 
    def model
      Video 
    end

end
