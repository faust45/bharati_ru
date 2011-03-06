module ZeroAuth
  extend ActiveSupport::Concern

  included do
    include ZeroAuth::User::Attributes
    include ZeroAuth::User::Methods
    include ZeroAuth::User::Authentication
  end

  def self.rand_hash
    ActiveSupport::SecureRandom.hex(32)
  end

end

