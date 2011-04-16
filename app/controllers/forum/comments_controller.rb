class Forum::CommentsController < ForumController
  helper 'forum/posts'

  def create
    @topic = Forum::Topic.get_doc!(params[:topic_id])
    @post = Forum::Post.get_doc!(params[:post_id])
    @comment = current_user.build_comment(params[:comment])

    @post << @comment

    unless @comment.new?
      redirect_to forum_topic_post_path(@topic, @post, :section => @comment.section)
    else
      render 'forum/posts/show'
    end
  end

  def destroy
    @topic   = Forum::Comment.get_doc!(params[:topic_id])
    @post    = Forum::Comment.get_doc!(params[:post_id])
    @comment = Forum::Comment.get_doc!(params[:id])

    if current_user.admin? or @comment.author == current_user
      @comment.destroy
    end

    flash[:notice] = "Комментарий был успешно удален"
    redirect_to forum_topic_post_path(@topic, @post)
  end

end
