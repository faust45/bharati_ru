module ForumHelper
  def login_panel
    if current_user.anonymous?
      link_to 'Login', '#', :class => 'login'
    else
      link_to current_user, '#', :class => 'ar user-nav'
    end
  end

  def avatar(user)
    unless user.photo_id.blank?
      image_tag(photo_thumb_url(user.photo_id, :width => 162, :height => 138)
    end
     
     # <img width="138" height="162" alt="" src="images/ava.jpg">
  end
end
