class Author < BaseModel

  ACHARYA = ['BNAcharyaMaharadzh', 'BSGovindaMaharadzh', '94263868']

  property :full_name
  property :display_name
  property :description

  use_as_id :display_name

  has_photo_attachment :main_photo, :thumb => {:size => 'x119'}
  has_attachments :photos, BigPhotoStore

  
  class <<self
    def get_all
      view_docs('authors_all')
    end

    def get_acharya
      ACHARYA.map do |id|
        self.get_doc!(id)
      end
    end

    def get_authors
      get_all - get_acharya
    end

    def get_by_name_or_create(display_name)
      author = get(display_name.to_couch_id)

      unless author.blank?
        create(:display_name => display_name)
      end
    end
  end


  def get_albums
    Album.get_by_author(self.id)
  end

  def get_tracks 
    Audio.get_by_author(self.id)
  end

  def get_tracks_by_year(year)
    Audio.get_by_author_and_year(self.id, year)
  end

  def get_years_with_tracks_count
    map = {}
    options = {
      :startkey => [self.id], 
      :endkey   => [self.id, {}, {}, {}], 
      :reduce   => true, 
      :group    => true
    }

    resp = view('audios_by_author_and_record_date', options)

    resp['rows'].each do |row|
      count = row['value']
      year  = row['key'][1]

      map[year] = count
    end

    map
  end

end
