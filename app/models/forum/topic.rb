class Forum::Topic < BaseModel

  property :title
  property :section_id
  property :description

  def to_s
    title
  end

  def <<(post)
    post.topic_id = self.id
    post
  end

  class <<self
    def all
      view_docs('forum', :key => ['ForumTopic', Forum.section])
    end

    def stat
      h = {}
      result = view('forum', :reduce => true, :group => true, :group_level => 3,
                             :startkey => [Forum.section],
                             :endkey   => [Forum.section, {}, {}])

      result['rows'].each do |r|
        id   = r['key'][1]
        type = r['key'][2]
        h[id] ||= {}
        h[id][type] = r['value']
      end

      h
    end
  end

  def posts
    Forum::Post.view_docs('forum', :key => [Forum.section, self.id, 'ForumPost'])
  end

  def last_active_post
    if last_active
      last_active.is_a?(Forum::Post) ? last_active : last_active.post
    end
  end

  def last_active
    [last_post, last_comment].compact.sort_by(&:created_at).last
  end

  def last_post
    Forum::Post.view_docs('forum', :key => [Forum.section, self.id, 'ForumPost'], :descending => true, :limit => 1).first
  end

  def last_comment
    Forum::Comment.view_docs('forum_comments', :key => [Forum.section, self.id, 'ForumComment'], :descending => true, :limit => 1).first
  end

  memoize :posts, :last_active, :last_post, :last_comment, :last_active_post
end
