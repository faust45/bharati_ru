class AudiosController < ApplicationController
  free_actions :index, :search, :album, :author, :year, :show, :bhagavatam, :books_vaishnava, :books_classic, :books, :kirtans, :kirtans_show

  def index
    @audios  = Audio.paginate(:get_all, :page => params[:page])

    common
    @page_title = "Аудио"
  end

  def common
    @acharya = Author.get_acharya
    @authors = Author.get_authors

    @books_classic = HHash.new(:title => 'Вайшнавские идеи в произведениях классиков', 
                               :icon => '0498a25066d3195129cff34b2762363c',
                               :description => 'Л.Н. Толстой, А.П. Чехов, Н.В. Гоголь и др.')
    @books_math    = HHash.new(:title => 'Вайшнавские аудиокниги', 
                               :icon => '0498a2467fb5d3547cdef53cc9c1a629',
                               :description => 'Бхагавад Гита, Шримад Бхагаватам и другие')

    @kirtans_menu  = HHash.new(:title => 'Шри Чайтанья Сарасват Матх - Шри-Хари-Киртан', 
                               :icon => '0498cc3536f3ea7ac794e017818542dc',
                               :description => 'Пение Шрилы Б.С. Говинды Махараджа и Шрилы Б.Р. Шридхара Махараджа')
  end

  def books
    @album = AudioBook.get_doc!(params[:id])
    @tracks = @album.get_tracks
    @current_track = @tracks.find{|el| el.id == params[:track_id]} 
    @current_track ||= @tracks.first

    @page_title    = "Аудиокнига - #{@album.author_display_name} #{@album}: #{@current_track}"
    @page_description = @album.description
    @page_keywords    = @album.keywords
  end

  def books_vaishnava
    common
    @audio_books = AudioBook.vaishnava 

    @page_title  = @books_math.title
    render :audio_books
  end

  def books_classic
    common
    @audio_books = AudioBook.classic

    @page_title  = @books_classic.title
    render :audio_books
  end

  def kirtans
    @kirtans = Kirtan.get_all
    common
    @page_title  = @kirtans_menu.title
  end

  def kirtans_show
    @album = Kirtan.get_doc!(params[:id])

    @tracks = @album.get_tracks
    if params[:track_id]
      @current_track = @tracks.find{|el| el.id == params[:track_id]} 
    else
      @current_track = @tracks.first
    end

    @page_description = @current_track.description
    #@author = @album.author
  end

  def album
    @album  = Album.get_doc!(params[:album_id])
    @tracks = @album.get_tracks
    if params[:id]
      @current_track = @tracks.find{|el| el.id == params[:id]} 
    else
      @current_track = @tracks.first
    end
    @author = @album.author

    @page_title    = "#{@album}: #{@current_track}"
    @page_keywords = @current_track.keywords
  end

  def author
    common
    @author = Author.get_doc!(params[:author_id])
    @albums = @author.get_albums
    @last_tracks = @author.paginate(:get_tracks, :page => params[:page])

    @years = @author.get_years_with_tracks_count

    @page_title = @author.to_s
  end

  def year
    @author = Author.get_doc!(params[:author_id])
    @year  = params[:year]
    @month = params[:month]

    unless @year.blank?
      @months_with_tracks =  @author.get_year_months(@year)

      if @month.blank?
        @month = @months_with_tracks.first.first 
      end

      @tracks = @author.get_tracks_by_year_month(@year, @month)

      if params[:track_id]
        @current_track = Audio.get_doc!(params[:track_id])
      else
        @current_track = @tracks.first
      end
    end

    @page_title    = "#{@author} - #{@year}: #{@current_track}"
    @page_description = @current_track.description
    @page_keywords = @current_track.keywords
    render :album
  end

  def bhagavatam
    @books = SbAlbum.get_all

    unless params[:book_num].blank?
      @album = @books.find{|b| b.book_num == params[:book_num]}
    end

    @album ||= @books.first
    @tracks = @album.get_tracks

    unless params[:track_id].blank?
      @current_track = @tracks.find{|track| track.id == params[:track_id]}
    end
    @current_track ||= @tracks.first

    @page_title    = "#{@album}: #{@current_track}"
    @page_description = @current_track.description
    @page_keywords = @current_track.keywords
    render :album
  end

  def show
    track = Audio.get_doc!(params[:id])
    path =
      if book = track.from_bhagavatam
        audios_bhagavatam_track_path(book.book_num, track.id)
      elsif (albums = track.get_albums).any?
        album_track_path(albums.first.id, track.id)
      else
        year = track.record_date.year
        month = track.record_date.month.to_s.rjust(2,'0')
        author_year_month_track_path(track.author.id, year, month, track.id)
      end

    redirect_to(path)
  end

  def block_title 
    'Лекции'
  end
  helper_method :block_title 


end
