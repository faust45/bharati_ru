module ZeroAuth::User::Methods

  def anonymous?
    false 
  end
  alias anon? anonymous?
     
  def logged_in?
    true 
  end

end

