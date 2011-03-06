class ZeroAuth::AnonymousUser
  def initialize(session)
    @session = session
  end

  def anonymous?
    true
  end
  alias anon? anonymous?
     
  def logged_in?
    false
  end

  def update_settings(attrs)
    session.merge!(attrs)
  end

  def settings
    @session
  end

  def bookmarks_for(audio)
    []
  end

  def can_add_bookmark?(bm)
    false
  end
end
