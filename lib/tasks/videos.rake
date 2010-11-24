
namespace :videos do
  desc "Fetch albums from vimeo"
  task :fetch_albums => :environment do
    albums = Vimeo::Simple::User.albums('bharatiru')

    albums.each do |album|
      VideoAlbum.create(album)
    end
  end

  desc "Fetch videos from vimeo"
  task :fetch_videos => :environment do
    VideoAlbum.get_all.each do |album|
      videos = Vimeo::Simple::Album.videos(album.id)
      videos.map! do |video|
        video['vimeo_id'] = video.delete('id')
        video['upload_at'] = video.delete('upload_date').to_time
        Video.create(video)
      end

      album.update_attributes(:videos => videos.map(&:id))
    end
  end
end

