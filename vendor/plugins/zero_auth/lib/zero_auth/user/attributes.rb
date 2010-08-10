module ZeroAuth::User::Attributes
  extend ActiveSupport::Concern

  included do
    unique_id :login

    property :login
    property :email
    property :crypt_password, :type => BCrypt::Password
    property :security_token, :type => ZeroAuth::SecurityToken

    #uniq :email

    alias :password :crypt_password
    attr_accessor :password_confirmation
    
    before_save { self.security_token = ZeroAuth::SecurityToken.new }
  end


  module InstanceMethods
    def password=(pass)
      self.crypt_password = BCrypt::Password.create(pass)
    end
  end

end
