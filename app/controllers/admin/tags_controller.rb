class Admin::TagsController < AdminController
  free_actions :autocomplete

  def autocomplete
    tags = Tag.like(params[:q])

    render :json => tags.join("\n").to_json
  end

end
