module ForumHelper
  def human_sex s
    case s
    when 'm': 'мужской'
    when 'w': 'женский'
    else 'не указан'
    end
  end

  def login_panel
    if current_user.anonymous?
      link_to 'Войти', '#', :class => 'login'
    else
      link_to current_user, '#', :class => 'ar user-nav'
    end
  end

  def avatar(user)
    unless user.photo_id.blank?
      image_tag(photo_thumb_url(user.photo_id, :width => 162, :height => 138))
    else
      image_tag(photo_thumb_url(User::DEFULT_AVATAR, :width => 162, :height => 138))
    end
  end

  def dd(date, prefix = nil)
    unless date.blank?
      date = l(date.to_date, :format => :long) 

      if prefix
        date += '&nbsp;' + prefix
      end

      (raw date).sub(/^0/, '')
    end
  end

  def d(date)
    str = super(date)

    unless str.blank?
      if date.year == Date.today.year
        str.sub!(date.year.to_s, '')
      end

      str = str.strip + ", #{date.to_s(:time)}"
      str.sub!(/^.*\,/, 'сегодня,') if date.today?
    end

    str
  end
end
