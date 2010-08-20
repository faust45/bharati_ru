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

    flexmock(Audio).new_instances do |m|
      m.should_receive(:assign_from_tags)
    end
    
    @audio = Audio.create(:title => 'Audio title', :source_file => @file)
  end

  before(:each) do
    flexmock(Audio).new_instances do |m|
      m.should_receive(:assign_from_tags)
    end
  end


  it 'should persist audio' do
    @audio.should_not be_new
  end

  it 'source_attachments should include original file name' do
    @audio.source.file_name.should be_eql(@file.original_filename)
  end

  it 'should assign correct duration' do
    @audio.duration.should be_eql(17 * 1000)
  end

  it 'should update' do
    audio = Audio.create(:title => 'Audio title')
    audio.update_attributes(:source_file => @file)
    audio = audio.reload

    audio.source.file_name.should  be_eql(@file.original_filename)
    audio.duration.should be_eql(17 * 1000)
  end
end


describe 'Audio mp3 attachments tags' do
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

    flexmock(FileStore).new_instances do |m|
      m.should_receive(:put_attachment)
    end
  end

  context 'assign title and record_date' do
    before(:each) do
      flexmock(Audio).new_instances do |m|
        m.should_receive(:assign_author)
        m.should_receive(:assign_tags)
        m.should_receive(:add_to_album)
      end
    end

    it 'should assign title and record_date' do
      audio = Audio.create(:title => 'Audio title', :source_file => @file)

      audio.title.should be_eql('O забавах')
      audio.record_date.should be_eql(Date.parse('2010.10.03'))
    end

    it 'should assign title, when date is absent' do
      info = HHash.new(:title => 'O забавах.')

      flexmock(Mp3Info).new_instances do |m|
        m.should_receive(:tag).and_return(info)
      end

      audio = Audio.create(:title => 'Audio title', :source_file => @file)
      audio.title.should be_eql('O забавах')
    end
  end

  it 'should assign tags' do
    flexmock(Audio).new_instances do |m|
      m.should_receive(:assign_author)
      m.should_receive(:assign_title_and_record_date)
      m.should_receive(:add_to_album)
    end

    audio = Audio.create(:title => 'Audio title', :source_file => @file)

    audio.tags.should include('Душа', 'Кришна', 'Праздник')
  end


  context 'assign new author' do
    before(:each) do
     Author.delete_all
     flexmock(Audio).new_instances do |m|
        m.should_receive(:assign_title_and_record_date)
        m.should_receive(:assign_tags)
        m.should_receive(:add_to_album)
      end
    end

    it 'should create new author' do
      lambda {
        Audio.create(:title => 'Audio title', :source_file => @file)
      }.should change{ Author.count }.by(+1)
    end

    it 'new author should have correct display_name' do
      audio = Audio.create(:title => 'Audio title', :source_file => @file)
      author = audio.author.get(Author)
      author.display_name.should be_eql('Б.Ч. Бхарати Махарадж')
    end

    it 'audio should have correct copy of author name' do
      audio = Audio.create(:title => 'Audio title', :source_file => @file)
      audio.author.name.should be_eql('Б.Ч. Бхарати Махарадж')
    end
  end
 
  context 'assign already exists author' do
    before(:each) do
     Author.delete_all
     @author = Author.create(:display_name => 'Б.Ч. Бхарати Махарадж')

     flexmock(Audio).new_instances do |m|
        m.should_receive(:assign_title_and_record_date)
        m.should_receive(:assign_tags)
        m.should_receive(:add_to_album)
      end
    end

    it 'should not create new author' do
      lambda {
        Audio.create(:title => 'Audio title', :source_file => @file)
      }.should change{ Author.count }.by(0)
    end

    it 'audio should have correct copy of author name' do
      audio = Audio.create(:title => 'Audio title', :source_file => @file)
      audio.author.name.should be_eql(@author.display_name)
    end
  end

  context 'assign new album' do
    before(:each) do
      Album.delete_all
      flexmock(Audio).new_instances do |m|
        m.should_receive(:assign_title_and_record_date)
        m.should_receive(:assign_tags)
        m.should_receive(:assign_author)
      end
    end

    it 'should create new album' do
      lambda {
        Audio.create(:title => 'Audio title', :source_file => @file)
      }.should change{ Album.count }.by(+1)
    end

    it 'new album should include current track' do
      audio = Audio.create(:title => 'Audio title', :source_file => @file)
      album = Album.first

      album.tracks.should include(audio.id)
    end

    it 'new album should have correct name' do
      audio = Audio.create(:title => 'Audio title', :source_file => @file)
      album = Album.first

      album.title.should be_eql('Вереницы уходят')
    end
  end

  context 'assign already exists album' do
    before(:each) do
      Album.delete_all
      @album = Album.create(:title => 'Вереницы уходят')

      flexmock(Audio).new_instances do |m|
        m.should_receive(:assign_title_and_record_date)
        m.should_receive(:assign_tags)
        m.should_receive(:assign_author)
      end
    end

    it 'should persist album' do
      @album.should_not be_new
    end

    it 'should not create new album' do
      lambda {
        Audio.create(:title => 'Audio title', :source_file => @file)
      }.should change{ Album.count }.by(0)
    end

    it 'album should include current track' do
      audio = Audio.create(:title => 'Audio title', :source_file => @file)
      
      @album = @album.reload
      @album.tracks.should include(audio.id)
    end
  end

end
