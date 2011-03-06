class Forum::ProfileController < ForumController

  def edit
  end

  def update 
    current_user.update(params[:user])
    render :edit
  end

end
