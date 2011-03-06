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
      image_tag('http://192.168.1.3:8000/' + user.photo_id + '?size=162x138')
    end
     
     # <img width="138" height="162" alt="" src="images/ava.jpg">
  end
end
