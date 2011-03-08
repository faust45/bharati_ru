class UsersController < ApplicationController
  layout :choose_layout
  free_actions :login, :logout, :create

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
    respond_to do |format|
      format.html {
        redirect_to :back
      }
      format.js {
        render :json => "ok"
      }
    end
  end

  def new
    @user = User.new(params[:user])
  end

  def create
    @user = User.new(params[:user])
    @user.save

    respond_to do |format|
      format.js {render :json => {:is_new => @user.new?, :errors => @user.errors}}
    end
  end

  def confirm
  end

  private
    def choose_layout
      request.xhr? ? nil : 'app'
    end

    def login_success
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js do
          render :json => {:login_success => true}
        end
      end
    end

    def login_fail
      respond_to do |format|
        format.html
        format.js do
          render :json => {:flash => flash[:notice]}
        end
      end
    end
end
