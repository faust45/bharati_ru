module ZeroAuth::User::Scopes

  def self.included(base)
    base.class_eval do
      named_scope :active, :conditions => {:verified => true}
    end
  end

end
