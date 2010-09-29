
namespace :videos do
  desc "Fetch albums from vimeo"
  task :fetch_albums => :environment do
    albums = Vimeo::Simple::User.albums('kanica')

    albums.each do |album|
      VideoAlbum.create(album)
    end
  end

  desc "Fetch videos from vimeo"
  task :fetch_videos => :environment do
    VideoAlbum.all.each do |album|
      videos = Vimeo::Simple::Album.videos(album.id)
      videos.map! do |video|
        Video.create(video)
      end

      album.update_attributes(:videos => videos.map(&:id))
    end
  end
end

