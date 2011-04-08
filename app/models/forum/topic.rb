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

  def last_active
    @last ||= [last_post, last_comment].sort_by(&:created_at).last
  end

  def last_active_post
    @last_active_post ||= last.is_a?(Forum::Post) ? last : last.post
  end

  def last_comment
    Forum::Comment.view_docs('forum_comments', :key => ['ForumTopic', self.id], :descending => true, :limit => 1).first
  end

end
