class About
  class<< self
    def bharati_ru
      HHash.new self['about']
    end

    def ychenie
     HHash.new self['ychenie']
    end

    def to_start
      HHash.new self['to_start']
    end

    def [](key) 
      @about = BaseModel.database.get('about_site')

      if @about[key.to_s]
        HHash.new @about[key.to_s] 
      end
    end
  end
end
