class Forum::Topic < BaseModel

  property :title
  property :description

  def to_s
    title
  end

  def <<(post)
    post.topic_id = self.id
    post
  end

  class <<self
    def stat
      h = {}
      posts = view('forum_posts', :reduce => true, :group => true)
      comments = view('forum_comments', :reduce => true,
                                        :group => true,
                                        :startkey => ['ForumTopic'],
                                        :endkey => ['ForumTopic', {}])

      posts['rows'].each do |r|
        h[r['key']] ||= {}
        h[r['key']][:posts] = r['value']
      end

      comments['rows'].each do |r|
        h[r['key'][1]][:comments] = r['value']
      end

      h
    end

  end

  def posts
    Forum::Post.view_docs('posts_by_topic_id', :key => self.id)
  end

  def last_post
    @last_post ||= Forum::Post.view_docs('posts_by_topic_id', :key => self.id, :descending => true, :limit => 1).first
  end

end