class Forum::TopicsController < ForumController
  free_actions_all

  def index
    @topics = Forum::Topic.all
    @stat = Forum::Topic.stat
  end

  def show
  end

end
