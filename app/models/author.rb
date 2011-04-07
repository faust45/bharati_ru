class Author < BaseModel

  ACHARYA      = %w(GovindaMj SridharMj)
  TEACHERS     = %w(GovindaMj SridharMj SarasvatiThakur BabajiGaurakishor BhaktivinodThakur DjaganathBabaji)
  ACHARYA_LIB  = %w(GovindaMj SridharMj SarasvatiThakur BhaktivinodThakur)
  AUTHORS_LIB  = %w(BharatiMj GoswamiMj SrutasravaPr)
  MATH_AUTHORS = %w(BharatiMj AcharyaMj GoswamiMj SrutasravaPr SiddhantiMj AvadhutMj)
  CLASSIC      = %w(Tolstoy Chekhov Gogol SaltykovWedrin Bunin Bulgakov Turgenev Goethe Goncharov)
  VAISHNAVA    = %w(Vjasadeva SridharMj)

  NAMES_IDS = {
    'Б.Н. Ачарья Махарадж'  => 'AcharyaMj',
    'Б.С. Говинда Махарадж' => 'GovindaMj',
    'Б.Р. Шридхар Махарадж' => 'SridharMj',
    'Б.С. Госвами Махарадж' => 'GoswamiMj',
    'Б.П. Сиддханти Махарадж' => 'SiddhantiMj',
    'Б.Л. Акинчан Махарадж'   => 'AkinchanMj',
    'Шруташрава Прабху'       => 'SrutasravaPr',
    'Б.Ч. Бхарати Махарадж'   => 'BharatiMj',
    'Б.Б. Авадхут Махарадж'   => 'AvadhutMj' 
  }.inject({}) {|h, (k, v)| h[k.to_couch_id] = v; h }

  property :full_name
  property :display_name
  property :description
  property :main_photo
  property :main_photo_inner
  property :main_photo_page_menu
  property :life_years
  property :short_bio
  property :bio
  #property :extracts, []
  property :photos_link
  property :audios_link
  property :videos_link
  property :publications_link

  use_as_id :id_by_display_name

  #has_photo_attachment :main_photo, :thumb => {:size => 'x119'}
  has_attachments :photos, BigPhotoStore

  
  class <<self
    def get_teachers
      get_all_docs(TEACHERS)
    end

    def get_all(options = {})
      @get_all ||= view_docs('authors_all', options)
    end

    def get_acharya
      get_all_docs(ACHARYA)
    end

    def get_acharya_lib
      @acharya_lib ||= get_all_docs(ACHARYA_LIB)
    end

    def get_authors
      @authors ||= get_all_docs(MATH_AUTHORS)
    end

    def get_math_authors
      get_all_docs(MATH_AUTHORS)
    end

    def get_authors_lib
      @authors_lib ||= get_all_docs(AUTHORS_LIB)
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

  def to_s
    display_name
  end

  def extracts
    []
  end

  def is_teacher?
    TEACHERS.include? self.id
  end

  def is_math_author?
    MATH_AUTHORS.include? self.id
  end

  def get_videos(options = {})
    Video.get_by_author(self.id, options)
  end

  def get_videos_by_year(year, options = {})
    Video.get_by_author_and_year(self.id, year, options)
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

  def get_tracks_by_year(year, options = {})
    Audio.get_by_author_and_year(self.id, year, options)
  end

  def get_tracks_by_year_month(year, month)
    Audio.get_by_author_and_year_month(self.id, year, month)
  end

  def get_year_months(year)
    map = ActiveSupport::OrderedHash.new 
    options = {
      :startkey => [self.id, year],
      :endkey   => [self.id, year, {}],
      :reduce   => true, 
      :group    => true
    }

    resp = view('audios_by_author_and_year_month', options)

    resp['rows'].each do |row|
      count = row['value']
      month = row['key'][2]

      map[month] = count
    end

    map
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

  def get_years_with_videos_count
    map = ActiveSupport::OrderedHash.new 
    options = {
      :startkey => [self.id], 
      :endkey   => [self.id, {}], 
      :reduce   => true, 
      :group    => true
    }

    resp = view('videos_by_author_and_year', options)

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
