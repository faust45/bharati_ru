class ZeroAuth::SecurityToken < Hash
  include ::CouchRest::CastedModel

  LIFETIME = 30.days

  property :token,  :default => proc{ ZeroAuth.rand_hash }
  property :expiry, :type => Time, :default => proc{ Time.now + LIFETIME }


  def expired?
    expiry < Time.now 
  end

  def to_s
    token
  end

end
