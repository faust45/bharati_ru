module AudioBookmarksHelper
  MS_IN_ONE_SEC = 1000

    def my_bm_id(bm)
    "my_bm_#{bm.id}" 
  end

  def my_bookmark
    escape_javascript render(:partial => 'audios/my_bookmark')
  end

  def link_to_share_or_private(bm)
    bm.is_shared? ? link_to_private(bm) : 
                    link_to_share(bm)
  end

  def link_to_private(bm)
    link_to('private', audio_bookmark_private_path(:bm_id => bm), :class => 'private')
  end

  def link_to_share(bm)
    link_to('share', audio_bookmark_share_path(:bm_id => bm), :class => 'share')
  end

  def link_to_owner(bm)
    if bm.is_copy?
      link_to(bm.original_owner_display_name, '#', :class => "user")
    else 
      link_to(bm.owner_display_name, '#', :class => "user")
    end
  end

  def view_as_json(bm)
    bm = bm.to_hash
    bm[:ftime] = ftime(bm.time)
    bm[:share_url] = audio_bookmark_share_path(:bm_id => bm['_id']) unless bm.new?
    bm[:del_url]   = audio_bookmark_delete_path(:bm_id => bm['_id']) unless bm.new?
    bm.to_json
  end

  def ftime(time_ms)
    ms = time_ms.to_i

    ms_in_hour = (MS_IN_ONE_SEC * 60 * 60)
    ms_in_min  = (MS_IN_ONE_SEC * 60)

    hour = ms / ms_in_hour  
    ms -= (hour * ms_in_hour) if 0 < hour

    min  = ms / ms_in_min
    ms -= (min * ms_in_min)   if 0 < min

    sec  = ms / MS_IN_ONE_SEC

    "#{hour.to_s.rjust(2, '0')}:#{min.to_s.rjust(2, '0')}:#{sec.to_s.rjust(2, '0')}"
  end
end
