module ContactsHelper
  def form_glance(doc, options = {}, &block) 
    FormGlance.new(doc, self, options, &block).to_s
  end


  def menu_glance(options = {}, &block)
    MenuGlance.new(self, options, &block).to_s
  end
end
