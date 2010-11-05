class UsersController < ApplicationController
  layout :choose_layout
  free_actions :login, :logout, :create, :new

  def login
    if request.post?
      if current_user.logged_in?
        session[:user_id] = current_user.id
        flash[:notice] = 'Login success'
        login_success
      else
        flash[:notice] = 'Login fail'
        login_fail
     end
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to :back
  end

  def new
    @user = User.new(params[:user])
  end

  def create
    @user = User.new(params[:user].dup)

    if @user.save
      redirect_back_or_default(new_admin_video_path)
    else
      render :action => :new
    end
  end

  def confirm
  end

  def change_css_style 
    if params[:css_style]
      current_user.update_settings(:css_style => params[:css_style])
    end
  end

private
  def choose_layout
    request.xhr? ? nil : 'app'
  end

  def login_success
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js do
        render :json => {:login_success => true}.to_json
      end
    end
  end

  def login_fail
    respond_to do |format|
      format.html
      format.js do
        render :json => {:flash => flash[:notice]}.to_json
      end
    end
  end
end
