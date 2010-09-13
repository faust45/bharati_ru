module Slug
  extend ActiveSupport::Concern

  module ClassMethods
    def as_slug(name, &block)
      property :slug

      before_save do
        if new?
          if self[:slug].blank? 
            self[:slug] = Russian::translit(self.send(name)).gsub(/[\s\.]/, '-')
          end
        end
      end
    end
  end
end
