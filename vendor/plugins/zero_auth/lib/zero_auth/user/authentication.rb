module ZeroAuth::User::Authentication
  extend ActiveSupport::Concern

  module ClassMethods
    def authenticate_by_token(token)
      # Allow logins for deleted accounts, but only via this method (and
      # not the regular authenticate call)
      #logger.info "Attempting authorization user with #{token}"

      if user = first(:conditions => ["security_token = ?", token])
        #logger.info "Authenticated by token: #{user.inspect}"

        unless user.security_token.expired?
          user.update_attribute(:verified, true)
        end
      else
        logger.info "Not authenticated"
      end

      user
    end

     def authenticate_by_login(login, pass)
       if user = self.first(:login => login)
         #logger.info "Attempting authenticate user #{login}"
         user if user.crypt_password == pass
       end
     end
  end

end
