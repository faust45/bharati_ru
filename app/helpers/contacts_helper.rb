module ContactsHelper
  MENU_ICONS = {
    :feedback => "/images/contacts/feedback.png",
    :on_other_sites => "/images/contacts/other.png",
    :contacts_links => "/images/contacts/links.png"
  }

  def feedback_icon(h)
    icon = MENU_ICONS[h[:type]]
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
