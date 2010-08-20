require File.expand_path(File.dirname(__FILE__) + "/../test_helper.rb")



class FileStoreTest < ActiveSupport::TestCase

  def setup
    FileStore.use_database TEST_SERVER.database('test_file_store')


    dir = Rails.root + 'spec/models/files/'
    @file = File.open(dir + '17_sec.mp3')
    class <<@file 
      def original_filename
        '17_sec.mp3'
      end
    end

    FileStore.delete_all
  end

  test 'assign content-type audio/mpeg' do
    content_type = 'audio/mpeg'
    @doc = FileStore.create(@file, :content_type => content_type)
    @doc = FileStore.get(@doc.id)

    assert_equal content_type, @doc['_attachments'][@file.original_filename]['content_type']
  end

  test 'assign content-type image/x-bmp' do
    content_type = "image/x-bmp"
    @doc = FileStore.create(@file, :content_type => content_type)
    @doc = FileStore.get(@doc.id)

    assert_equal content_type, @doc['_attachments'][@file.original_filename]['content_type']
  end

end


class AudioTest < ActiveSupport::TestCase

  def setup
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

    @audio = Audio.create(:title => 'Audio title', :source_file => @file)
  end

  test 'source_attachments should include original file name' do
    assert_not_equal @file.original_filename, @audio.source.file_name
  end

end


