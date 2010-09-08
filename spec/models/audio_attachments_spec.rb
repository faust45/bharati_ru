require 'spec_helper'


describe 'Audio mp3 attachments' do
  before(:all) do
    FileStore.use_database TEST_SERVER.database('test_file_store')
    Audio.use_database TEST_SERVER.database('test_audio')

    dir = Rails.root + 'spec/models/files/'
    @file = File.open(dir + '17_sec.mp3')
    class <<@file 
      def original_filename
        '17_sec.mp3'
      end
    end

    FileStore.delete_all
    Audio.delete_all

    flexmock(SourceAudioAttachmentStore).new_instances do |m|
      m.should_receive(:assign_from_tags)
    end
    
    @audio = Audio.create(:source_file => @file)
    @attach = SourceAudioAttachmentStore.get(@audio.source.doc_id)
  end

  before(:each) do
    flexmock(SourceAudioAttachmentStore).new_instances do |m|
      m.should_receive(:assign_from_tags)
    end
  end


  it 'should persist audio and attachment' do
    @audio.should_not be_new
    @attach.should_not be_new
  end

  it 'source should have original file_name' do
    @audio.source.file_name.should be_eql(@file.original_filename)
  end

  it 'should assign original file_name' do
    @attach.file_name.should be_eql(@file.original_filename)
  end

  it 'should assign correct duration' do
    @attach.duration.should be_eql(17 * 1000)
  end

  it 'should assign content_type audio/mpeg' do
    @attach['_attachments'][@file.original_filename]['content_type'].should be_eql('audio/mpeg')
  end

end


describe 'SourceAudioAttachmentStore' do
  # @file has tags:
  #   title:  'O забавах. 2010.10.03'
  #   artist: 'Б.Ч. Бхарати Махарадж'
  #   album:  'Вереницы уходят.'
  #   composer(tags): 'Душа, Кришна, Праздник'
  #
  #
  before(:all) do
    FileStore.use_database TEST_SERVER.database('test_file_store')

    dir = Rails.root + 'spec/models/files/'
    @file = File.open(dir + '17_sec.mp3')
    class <<@file 
      def original_filename
        '17_sec.mp3'
      end
    end

    FileStore.delete_all

    flexmock(SourceAudioAttachmentStore).new_instances do |m|
      #m.should_receive(:put_attachment)
    end
  end


  it 'should mock Mp3Info tags correct' do
    info = HHash.new('TT2' => 'New cool title')

    flexmock(Mp3Info).new_instances do |m|
      m.should_receive(:tag2).and_return(info)
    end

    attach = SourceAudioAttachmentStore.create(@file)
    attach.title.should be_eql('New cool title')
  end

  context 'assign title and record_date' do
    before(:each) do
      flexmock(SourceAudioAttachmentStore).new_instances do |m|
        m.should_receive(:assign_author)
        m.should_receive(:assign_tags)
        m.should_receive(:assign_album)
      end
    end

    it 'should assign title and record_date' do
      attach = SourceAudioAttachmentStore.create(@file)

      attach.title.should be_eql('O забавах')
      attach.record_date.should be_eql(Date.parse('2010.10.03'))
    end

    it 'should assign title, when date is absent' do
      info = HHash.new('TT2' => 'O забавах.')

      flexmock(Mp3Info).new_instances do |m|
        m.should_receive(:tag2).and_return(info)
      end

      attach = SourceAudioAttachmentStore.create(@file)
      attach.title.should be_eql('O забавах')
    end
  end

  it 'should assign tags' do
    flexmock(SourceAudioAttachmentStore).new_instances do |m|
      m.should_receive(:assign_author)
      m.should_receive(:assign_title_and_record_date)
      m.should_receive(:assign_album)
    end

    attach = SourceAudioAttachmentStore.create(@file)
    attach.tags.should include('Душа', 'Кришна', 'Праздник')
  end

  it 'should assign author_name' do
    flexmock(SourceAudioAttachmentStore).new_instances do |m|
      m.should_receive(:assign_tags)
      m.should_receive(:assign_title_and_record_date)
      m.should_receive(:assign_album)
    end

    attach = SourceAudioAttachmentStore.create(@file)
    attach.author_name.should be_eql('Б.Ч. Бхарати Махарадж')
  end

  it 'should assign album' do
    flexmock(SourceAudioAttachmentStore).new_instances do |m|
      m.should_receive(:assign_tags)
      m.should_receive(:assign_title_and_record_date)
      m.should_receive(:assign_author)
    end

    attach = SourceAudioAttachmentStore.create(@file)
    attach.album_name.should be_eql('Вереницы уходят')
  end

end


describe 'SourceAudioAttachmentStore replace' do
  # @file_new has tags:
  #   title:  'Roberto Song true. 2010.10.03.'
  #   artist: 'Solo'
  #   album:  'Pointer test'
  #   composer(tags): 'Cool, Street, View'
  #
  #
  
  before(:all) do
    FileStore.use_database TEST_SERVER.database('test_file_store')

    dir = Rails.root + 'spec/models/files/'
    @file = File.open(dir + '17_sec.mp3')
    class <<@file 
      def original_filename
        '17_sec.mp3'
      end
    end

    @file_new = File.open(dir + '20_sec.mp3')
    class <<@file_new
      def original_filename
        '20_sec.mp3'
      end
    end

    FileStore.delete_all
    @attach = SourceAudioAttachmentStore.create(@file)
    @attach = SourceAudioAttachmentStore.get(@attach.id)
    @attach.replace(@file_new)
  end

  before(:each) do
  end

  it 'should assign new title' do
    @attach.title.should be_eql('Roberto Song true. ')
  end

  it 'should assign new author_name' do
    @attach.author_name.should be_eql('Solo')
  end

  it 'should assign new album_name' do
    @attach.album_name.should be_eql('Pointer test')
  end

  it 'should assign new record_date' do
    @attach.record_date.should be_eql(Date.parse('2010.10.03'))
  end

  it 'should assign new tags' do
    @attach.tags.should include('Cool', 'Street', 'View')
  end

end


describe 'Audio create' do
  # @file has tags:
  #   title:  'O забавах. 2010.10.03'
  #   artist: 'Б.Ч. Бхарати Махарадж'
  #   album:  'Вереницы уходят.'
  #   composer(tags): 'Душа, Кришна, Праздник'
  #
  #
 
  before(:all) do
    FileStore.use_database TEST_SERVER.database('test_file_store')
    Audio.use_database TEST_SERVER.database('test_audio')
    Album.use_database TEST_SERVER.database('test_audio')
    Author.use_database TEST_SERVER.database('test_author')

    dir = Rails.root + 'spec/models/files/'
    @file = File.open(dir + '17_sec.mp3')
    class <<@file 
      def original_filename
        '17_sec.mp3'
      end
    end

    FileStore.delete_all
    Audio.delete_all
    Author.delete_all
    Album.delete_all

    flexmock(SourceAudioAttachmentStore).new_instances do |m|
      #m.should_receive(:put_attachment)
    end
  end

  before(:each) do
  end

  it 'should assign title' do
    audio = Audio.create(:source_file => @file)
    audio.title.should be_eql('O забавах')
  end

  it 'should assign record_date' do
    audio = Audio.create(:source_file => @file)
    audio.record_date.should be_eql(Date.parse('2010.10.03'))
  end

  it 'should assign author, when author exist' do
    Author.delete_all

    author = Author.create(:display_name => 'Б.Ч. Бхарати Махарадж')
    author.should_not be_new

    audio = Audio.create(:source_file => @file)
    audio.author.name.should be_eql('Б.Ч. Бхарати Махарадж')
  end

  it 'should create new author, when author not exist' do
    Author.delete_all
    lambda {
      Audio.create(:source_file => @file)
    }.should change{ Author.count }.by(+1)
  end

  it 'should assign author, when author not exist' do
    Author.delete_all

    audio = Audio.create(:source_file => @file)
    audio.author.name.should be_eql('Б.Ч. Бхарати Махарадж')
  end

  it 'should assign tags' do
    audio = Audio.create(:source_file => @file)
    audio.tags.should include('Душа', 'Кришна', 'Праздник')
  end

  it 'should add track to album, when album exist' do
    Album.delete_all

    album = Album.create(:title => 'Вереницы уходят')
    album.should_not be_new

    audio = Audio.create(:source_file => @file)
    album = Album.get(album.id)

    album.tracks.should include(audio.id)
  end

  it 'should create new album, when album not exist' do
    Album.delete_all
    lambda {
      Audio.create(:source_file => @file)
    }.should change{ Album.count }.by(+1)
  end

  it 'should create new album with correct name, when album not exist' do
    Album.delete_all
    audio = Audio.create(:source_file => @file)

    album = Album.first
    album.title.should be_eql('Вереницы уходят')
  end

  it 'should add track to album, when album not exist' do
    Album.delete_all

    audio = Audio.create(:source_file => @file)
    album = Album.first
    album.tracks.should include(audio.id)
  end

end


describe 'Audio replace attachment' do
  # @file_new has tags:
  #   title:  'Roberto Song true. 2010.10.03.'
  #   artist: 'Solo'
  #   album:  'Pointer test'
  #   composer(tags): 'Cool, Street, View'
  #
  #
 
  before(:all) do
    FileStore.use_database TEST_SERVER.database('test_file_store')
    Audio.use_database TEST_SERVER.database('test_audio')
    Album.use_database TEST_SERVER.database('test_audio')
    Author.use_database TEST_SERVER.database('test_author')

    dir = Rails.root + 'spec/models/files/'
    @file = File.open(dir + '17_sec.mp3')
    class <<@file 
      def original_filename
        '17_sec.mp3'
      end
    end

    @file_new = File.open(dir + '20_sec.mp3')
    class <<@file_new
      def original_filename
        '20_sec.mp3'
      end
    end

    FileStore.delete_all
    Audio.delete_all
    Author.delete_all
    Album.delete_all

    @audio = Audio.create(:source_file => @file)
    @old_source = @audio.source.clone
    @audio.source_replace(@file_new, true)
  end

  before(:each) do
  end

  it 'should assign title' do
    @audio.title.should be_eql('Roberto Song true. ')
  end

  it 'should assign new author_name' do
    @audio.author.name.should be_eql('Solo')
  end

  it 'should create new album' do
    album = Album.by_title(:key => 'Pointer test')
    album.should_not be_blank
  end

  it 'new album should include track' do
    album = Album.first
    album.tracks.should include(@audio.id)
  end

  it 'should assign new record_date' do
    @audio.record_date.should be_eql(Date.parse('2010.10.03'))
  end

  it 'should assign new tags' do
    @audio.tags.should include('Cool', 'Street', 'View')
  end

  it 'should replace file_name' do
    @audio.source.file_name.should be_eql(@file_new.original_filename)
  end

  it 'should not replace doc_id' do
    @audio.source.doc_id.should be_eql(@old_source.doc_id)
  end

end
