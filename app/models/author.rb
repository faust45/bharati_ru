class Author < BaseModel

  ACHARYA = ['AcharyaMj', 'GovindaMj', 'SridharMj']
  ACHARYA_LIB = ['SridharMj', 'SarasvatiThakur', 'BhaktivinodThakur']

  NAMES_IDS = {
    'Б.Н. Ачарья Махарадж'  => 'AcharyaMj',
    'Б.С. Говинда Махарадж' => 'GovindaMj',
    'Б.Р. Шридхар Махарадж' => 'SridharMj',
    'Б.С. Госвами Махарадж' => 'GoswamiMj',
    'Б.П. Сиддханти Махарадж' => 'SiddhantiMj',
    'Б.Л. Акинчан Махарадж'   => 'AkinchanMj',
    'Шруташрава Прабху'       => 'SrutasravaPr',
    'Б.Ч. Бхарати Махарадж'   => 'BharatiMj'
  }.inject({}) {|h, (k, v)| h[k.to_couch_id] = v; h }

  property :full_name
  property :display_name
  property :description

  use_as_id :id_by_display_name

  #has_photo_attachment :main_photo, :thumb => {:size => 'x119'}
  has_attachments :photos, BigPhotoStore

  
  class <<self
    def get_all
      view_docs('authors_all')
    end

    def get_acharya
      @acharya ||= ACHARYA.map do |id|
        self.get_doc!(id)
      end
    end

    def get_acharya_lib
      @acharya_lib ||= ACHARYA_LIB.map do |id|
        self.get_doc!(id)
      end
    end

    def get_authors
      ids = (ACHARYA + ACHARYA_LIB).uniq
      @authors ||= get_all.reject{|author| 
        ids.include?(author.id)
      }
    end

    def get_by_name_or_create(display_name)
      author = get(id_by_name(display_name))

      if author.blank?
        create(:display_name => display_name)
      else
        author
      end
    end

    def id_by_name(name)
      NAMES_IDS[name.to_couch_id]
    end

    def display_name_by_id(author_id)
      @cache_authors_names ||= Author.get_all.inject({}) do |h, doc|
        h[doc.id] = doc.display_name
        h
      end

      @cache_authors_names[author_id]
    end
  end

  def main_photo
    if self['main_photo_attachments_tmp']
      self['main_photo_attachments_tmp'][0]
    end
  end

  def get_publications(options = {})
    Publication.get_by_author_or_translator(self.id, options)
  end

  def get_albums
    Album.get_by_author(self.id)
  end

  def get_tracks(options = {})
    Audio.get_by_author(self.id, options)
  end

  def get_tracks_by_year(year)
    Audio.get_by_author_and_year(self.id, year)
  end

  def get_years_with_tracks_count
    map = ActiveSupport::OrderedHash.new 
    options = {
      :startkey => [self.id], 
      :endkey   => [self.id, {}], 
      :reduce   => true, 
      :group    => true
    }

    resp = view('audios_by_author_and_year', options)

    resp['rows'].each do |row|
      count = row['value']
      year  = row['key'][1]

      map[year] = count
    end

    map
  end

  def get_books(options = {})
    Publication.get_books_by_author(self.id, options)
  end

  def get_articles(options = {})
    Publication.get_articles_by_author(self.id, options)
  end

  def id_by_display_name
    self.class.id_by_name(self.display_name)
  end

  def to_link
    display_name
  end

  def to_url_params
    {:author_id => self.id}
  end

end
