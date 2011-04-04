class Forum::ProfileController < ForumController
  free_actions :index, :show

  def index
    @users = User.all
  end

  def show
    @user = User.first(:login => params[:login])
  end

  def edit
    @user = User.get(params[:id])
    @profile = @user.profile
  end

  def update 
    current_user.update(params[:user])

    render :edit
  end

end
