require 'spec_helper'

class Audio 
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

    @audio = Audio.create(:title => 'Audio title', :source => @file)
  end

  it 'should persist audio' do
    @audio.should_not be_new
  end

  it 'source_attachments should include original file name' do
    @audio.source_attachments.should include(@file.original_filename)
  end

  it 'should assign correct duration' do
    @audio.duration.should be_eql(18 * 1000)
  end

  it 'should update' do
    audio = Audio.create(:title => 'Audio title')
    audio.update_attributes(:source => @file)
    audio = audio.reload

    audio.source_attachments.should include(@file.original_filename)
    audio.duration.should be_eql(18 * 1000)
  end

end


