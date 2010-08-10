require 'spec_helper'

class Album
  use_database TEST_SERVER.default_database
end


describe Album do
  before(:all) do
    @audio1 = Audio.create(:title => 'audio1')
    @audio2 = Audio.create(:title => 'audio2')
    @audio3 = Audio.create(:title => 'audio3')
  end

  before(:each) do
    Album.delete_all
    @album = Album.new(:title => 'Some Cool album')
    @album.sort_type = :custom
    @album.save(false)
  end

  it 'should be persistent' do
    @album.should_not be_new
    @audio1.should_not be_new
    @audio2.should_not be_new
    @audio3.should_not be_new
  end

  it 'should add tracks' do
    @album << @audio1
    @album = @album.reload
    @album.tracks.should include(@audio1.id)
  end

  it 'should get tracks in save order' do
    @album << @audio3
    @album << @audio1
    @album << @audio2
    @album = @album.reload

    tracks = @album.get_tracks
    tracks[0].id.should be_eql(@audio3.id)
    tracks[1].id.should be_eql(@audio1.id)
    tracks[2].id.should be_eql(@audio2.id)
  end

end
