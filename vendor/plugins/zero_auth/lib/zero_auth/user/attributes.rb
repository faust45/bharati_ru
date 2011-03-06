module ZeroAuth::User::Attributes
  extend ActiveSupport::Concern

  included do
    class_eval do
      property :id,       DataMapper::Property::Serial
      property :login,    DataMapper::Property::String, :required => true, :unique => true
      property :email,    DataMapper::Property::String, :required => true, :unique => true
      property :crypt_password, DataMapper::Property::BCryptHash, :required => true
      property :security_token, DataMapper::Property::String

      validates_length_of :login, :min => 4
      validates_length_of :password, :min => 4, :if => :new?
      #before :create do 
      #  self.security_token = ZeroAuth::SecurityToken.new
      #end
    end
  end

  module InstanceMethods
    def password
      @password
    end

    def password=(pass)
      @password = pass
      self.crypt_password = pass
    end
  end
end
