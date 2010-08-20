require 'spec_helper'


describe 'FileStore' do
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
  end

  it 'should assign content-type audio/mpeg' do
    content_type = 'audio/mpeg'
    @doc = FileStore.create(@file, :content_type => content_type)
    @doc = FileStore.get(@doc.id)

    @doc['_attachments'][@file.original_filename]['content_type'].should be_eql(content_type)
  end

  it 'should assign content-type image/x-bmp' do
    content_type = "image/x-bmp"
    @doc = FileStore.create(@file, :content_type => content_type)
    @doc = FileStore.get(@doc.id)

    @doc['_attachments'][@file.original_filename]['content_type'].should be_eql(content_type)
  end

end


describe 'Attachments module' do
end
