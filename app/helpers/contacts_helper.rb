module ContactsHelper
  MENU_ICONS = {
    :feedback => "/images/contacts/feedback.png",
    :on_other_sites => "/images/contacts/other.png",
    :contacts_links => "/images/contacts/links.png"
  }

  MENU_TEXT = {
    :feedback => "Обратная связь",
    :on_other_sites => '<span class="white">Бхарати</span>.ру на других сайтах',
    :contacts_links => "Ссылки"
  }

  def feedback_icon(section)
    icon = MENU_ICONS[section]
    image_tag(icon, :height => "120", :width => "86")
    #photo_thumb(icon, {:height => "120", :width => "86"}, true)
  end

  def feedback_text(section)
    MENU_TEXT[section]
  end

  def form_glance(doc, options = {}, &block) 
    FormGlance.new(doc, self, options, &block).to_s
  end


  def menu_glance(options = {}, &block)
    MenuGlance.new(self, options, &block).to_s
  end
end
