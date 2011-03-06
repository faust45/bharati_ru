module ZeroAuth::ControllerExtensions
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
    before_filter :login_required
  end

  module InstanceMethods
    protected

    # before_filter :login_required
    def login_required
      session[:return_to] = (request.fullpath == '/logout' ?  nil : request.fullpath)
      access_denied if current_user.anonymous?
    end

    def current_user
      @current_user ||= (auth_by_session || auth_by_login || auth_by_token || anonymous)
    end

    # авторизация из сессионных кук
    def auth_by_session
      if session[:user_id]
        logger.info "Login_from_session #{session[:user_id]}"
        ::User.get(session[:user_id])
      end
    end

    # авторизация по логину и паролю
    def auth_by_login
      if params[:user]
        login, password = params[:user][:login], params[:user][:password]
        logger.info "Login_from_basic_auth #{login}"
        ::User.authenticate_by_login(login, password) if login && password
      end
    end

    # авторизация по ключу (после регистрации или смене пароля)
    def auth_by_token
      if params[:key]
        ::User.authenticate_by_token(params[:key])
      end
    end

    def access_denied
      flash[:notice] = "Для доступа к этой части сайта требуется авторизация."
  
      redirect_to login_path
    end

    def redirect_back_or_default(default)
      redirect_to(params[:return_to] || session[:return_to] || default)
      session[:return_to] = nil
    end

    def action_path
      "#{params[:controller]}/#{params[:action]}"
    end

    def anonymous
      ZeroAuth::AnonymousUser.new(session)
    end
  end


  module ClassMethods
    def free_actions(*actions)
      skip_before_filter :login_required, :only => actions
    end

    def free_actions_all
      skip_before_filter :login_required
    end
  end

end
