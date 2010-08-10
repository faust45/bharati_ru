module Admin::VideosHelper

  def videos_path
    admin_videos_path
  end

  def object_name
    'video'
  end

  def video_tr(video)
    content_tag(:tr) do
      content_tag(:td, video.title) +
      content_tag(:td, link_to_edit(edit_admin_video_path(video)))
    end
  end

  def content
    @video
  end

end
