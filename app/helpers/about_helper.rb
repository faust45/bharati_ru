module AboutHelper
  ABOUT = {
     :about => '<span class="white">',
     :ychenie    => '',
     :to_start   => ''
    }

  MAP = {
    'about' => 'about',
    'about_ychenie' => 'ychenie',
    'about_to_start' => 'to_start',
  }

  def have_inner_photo(about_section)
    !about_section.main_photo_big.blank?
  end

  def about_icon(h)
    icon = About[h.type].main_photo_icon
    photo_thumb(icon, {:height => "120", :width => "86"}, true)
  end

  def about_inner_photo
    if @about.main_photo_big
      photo_thumb(@about.main_photo_big, {:width => 281, :height => 202}, true)
    else
      ''
    end
  end

  def about_text(section)
    section = MAP[section.to_s]
    ABOUT[section.to_sym]
  end
end
