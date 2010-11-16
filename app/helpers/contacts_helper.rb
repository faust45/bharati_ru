module ContactsHelper
  def form_glance(doc, options = {}, &block) 
    FormGlance.new(doc, self, options, &block).to_s
  end
end
