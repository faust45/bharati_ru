require 'spec_helper'

class Audio 
  use_database TEST_SERVER.default_database
end

class FileStore
  TEST_SERVER.default_database = 'test_file_store'
  use_database TEST_SERVER.default_database
end


describe 'Attachments module' do
  before(:all) do
    dir = Rails.root + 'spec/models/files/'
    @file = File.open(dir + '17_sec.mp3')
    class <<@file 
      def original_filename
        '17_sec.mp3'
      end
    end

    @audio = Audio.create(:title => 'Audio title', :source_file => @file)
  end

  it 'should persist audio' do
    @audio.should_not be_new
  end

  it 'source_attachments should include original file name' do
    @audio.source.file_name.should  be_eql(@file.original_filename)
  end

  it 'should assign correct duration' do
    @audio.duration.should be_eql(18 * 1000)
  end

  it 'should update' do
    audio = Audio.create(:title => 'Audio title')
    audio.update_attributes(:source_file => @file)
    audio = audio.reload

    audio.source.file_name.should  be_eql(@file.original_filename)
    audio.duration.should be_eql(18 * 1000)
  end

  it 'should assign content-type' do
    doc = FileStore.get(@audio.source.doc_id)
    doc['_attachments'][@audio.source.file_name]['content_type'].should be_eql('audio/mpeg')
  end

end
