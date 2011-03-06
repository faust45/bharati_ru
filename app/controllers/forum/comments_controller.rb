class Forum::CommentsController < ForumController
  helper 'forum/posts'

  def create
    @topic = Forum::Topic.get_doc!(params[:topic_id])
    @post = Forum::Post.get_doc!(params[:post_id])
    @comment = current_user.build_comment(params[:comment])

    @post << @comment

    unless @comment.new?
      redirect_to forum_topic_post_path(@topic, @post)
    else
      render 'forum/posts/show'
    end
  end

end
