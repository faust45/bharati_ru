module SearchHelper

  def search_in_audios
    if !params[:author_id].blank?
      link_to 'По всем аудио', audios_search_in_author_path(params[:author_id], :q => params[:q])
    else
      link_to 'По всем аудио', audios_search_path(:q => params[:q])
    end
  end

  def search_in_current
    'По этому разделу'
  end

  def search_in_author(author)
    if is_scoped_by_author(author.id)
      content_tag(:span, author.display_name)
    else
      link_to author.display_name, audios_search_in_author_path(author.id, :q => params[:q])
    end
  end

  def search_in_all_authors
    if is_scoped_by_author(nil)
      content_tag(:span, 'по всем автарам')
    else
      link_to 'по всем авторам', audios_search_path(:q => params[:q])
    end
  end

  def is_scoped_by_author(author_id)
    params[:author_id] == author_id
  end

  #def current_path_item 
  #  "<div class='searchText'>поиск по слову “#{params[:q]}”</div>".html_safe
  #end

end
