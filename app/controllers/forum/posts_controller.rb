class Forum::PostsController < ForumController
  free_actions :index, :show

  def index
    @topic = Forum::Topic.get_doc!(params[:topic_id])
    @posts = @topic.posts

    @stat = Forum::Post.stat
  end

  def show
    @topic = Forum::Topic.get_doc!(params[:topic_id])
    @post = Forum::Post.get_doc!(params[:id])
    @comments = @post.comments
  end

  def new
    @topic = Forum::Topic.get_doc!(params[:topic_id])
    @post = Forum::Post.new
  end

  def create
    @topic = Forum::Topic.get_doc!(params[:topic_id])
    @post = current_user.build_post(params[:post])
    @topic << @post

    if @post.save
      redirect_to forum_topic_post_path(@topic, @post)
    else
      render :new
    end
  end

end
