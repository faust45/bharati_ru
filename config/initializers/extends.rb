class Integer
  CHARS62 = ("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a 

  def to_base62
    base = 62 
    i = self
    res = [] 

    while i > 0 
      ost = i % base
      i = i / base 
      res << CHARS62[ost]
    end

    res.reverse.join
  end
end

class Time
  def to_couch_id
    time = self.to_f
    ms = (time % 1 * 100000).to_i
    ms_str = ms.to_s.rjust(5, '0')
    l = (time.to_i.to_s + ms_str).to_i
    l.to_base62
  end
end

class String
  def to_couch_id
    value = Russian::translit(self)
    value.gsub(/[^A-Za-z\d]/, '')
  end
end


module CouchRest
  module Model
    module DesignDoc
      
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        
        def save_design_doc(*args); end
        def design_doc
        end

      end
    end
  end
end
