require 'spec_helper'

describe 'AudioBookmark' do

  before(:all) do 
    @user = User.new(:login => 'Vasilek')
    @track = Audio.new(:title => 'some cool audio')

    @user.save(false)
    @track.save(false)

    @bm = @track.new_bookmark(:title => 'bookmark 1', :time => 1)
    @bm.save(false)
  end

  it 'user, track and bm should persist' do
    @user.should_not  be_new
    @track.should_not be_new
    @bm.should_not    be_new
  end

  it 'should return instance of AudioBookmark' do
    new_copy = @bm.copy
    new_copy.should be_kind_of(AudioBookmark)
  end

  it 'should be a new doc' do
    new_copy = @bm.copy
    new_copy.should be_new 
  end

  it 'should assign origin_id' do
    new_copy = @bm.copy
    new_copy.original_id.should eql(@bm.id) 
  end

  it 'should assign owner_id' do
    new_copy = @bm.copy
    @user << new_copy

    new_copy.owner_id.should eql(@user.id)
  end

  it 'should copy title' do
    new_copy = @bm.copy
    new_copy.title.should eql(@bm.title) 
  end

  it 'should copy time' do
    new_copy = @bm.copy
    new_copy.time.should eql(@bm.time) 
  end

  it 'should create new bm' do
    new_copy = @bm.copy
    @user << new_copy

    new_copy.save
    new_copy.should_not be_new 
  end

end
