class Admin::VideosController < AdminController

  def index
    @videos = Video.all(:limit => 10)
  end

  def update
  end

end
