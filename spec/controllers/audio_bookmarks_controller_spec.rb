require 'spec_helper'

describe AudioBookmarksController do

  before(:all) do 
    @user  = User.new(:login => 'Vasilek')
    @faust = User.new(:login => 'faust')
    @track = Audio.new(:title => 'some cool audio')

    @faust.save(false)
    @user.save(false)
    @track.save(false)

    @bm = @track.new_bookmark(:title => 'some cool bookmarck', :time => 1)
    @user << @bm
    @bm.save(false)
  end

  before(:each) do
    loggin_as(@faust)
  end

  it 'should add bookmark' do
    lambda {
      get :copy, :id => 1, :bm_id => @bm.id
    }.should change{ AudioBookmark.count }.by(1)
  end

  it 'user should have bookmark for track' do
    get :copy, :id => 1, :bm_id => @bm.id

    bm = @faust.bookmarks_for(@track).first
    bm.should be_kind_of(AudioBookmark)
  end

  it 'should find bookmark and receive copy' do
    AudioBookmark.should_receive(:get!).with(@bm.id).and_return(@bm)
    @bm.should_receive(:copy)

    get :copy, :id => 1, :bm_id => @bm.id
  end

end
