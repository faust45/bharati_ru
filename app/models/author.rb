class Author < BaseModel

  ACHARYA = ['BNAcharyaMaharadzh', 'BSGovindaMaharadzh', '94263868']

  property :full_name
  property :display_name
  property :description

  use_as_id :display_name

  has_photo_attachment :main_photo, :thumb => {:size => 'x119'}
  has_attachments :photos, BigPhotoStore

  view_by :full_name
  view_by :display_name

  search_index <<-JS
    if(doc['couchrest-type'] && doc['couchrest-type'] == 'Author') {
      var ret = new Document();
      ret.add(doc.display_name, {"store": "yes"});
      return ret;
    }
  JS


  class <<self
    def get_acharya
      ACHARYA.map do |id|
        self.get_doc!(id)
      end
    end

    def get_authors
      all - get_acharya
    end

    def get_by_name_or_create(display_name)
      authors = by_display_name(:key => display_name)

      unless authors.blank?
        authors.first
      else
        create(:display_name => display_name)
      end
    end
  end

  def albums
    Album.get_by_author(self.id)
  end

  def last_tracks
    id = self.id
    Audio.by_author_last(:startkey => [id, {}], :endkey => [id], :limit => 10, :descending => true)
  end

  def years_with_tracks
    years = []
    resp = Audio.by_author_years(:reduce => true, :startkey => [self.id], :endkey => [self.id, {}], :group => true)
    resp['rows'].each do |row|
      year = row['key'][1]
      years << {:year => year, :count => row['value']} 
    end

    years
  end

  def tracks_by_year(year)
    Audio.by_author_and_year(:startkey => [self.id, year], :endkey => [self.id, year, {}])
  end

end
