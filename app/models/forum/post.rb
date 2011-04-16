class Forum::Post < Forum::Message

  property :title

  validates_presence_of :title

  class <<self
    def stat(topic_id)
      h = {}
      result = view('forum', :reduce => true,
                             :group_level => 4,
                             :startkey => [Forum.section, topic_id, 'ForumComment'],
                             :endkey   => [Forum.section, topic_id, 'ForumComment', {}])

      result['rows'].each do |r|
        id   = r['key'][3]
        h[id] = r['value']
      end

      h
    end
  end

  def to_s
    body 
  end

  def <<(comment)
    raise "Could't add comment to not saved post" if self.new?

    comment.post_id     = self.id
    comment.topic_id    = self.topic_id
    comment.section = self.section
    comment.save
  end

  def comments
    Forum::Comment.view_docs('forum', :key => [Forum.section, self.topic_id, 'ForumComment', self.id])
  end

  def last_comment
    Forum::Comment.view_docs('forum', :key => [Forum.section, self.topic_id, 'ForumComment', self.id], 
                                      :descending => true, 
                                      :limit => 1).first
  end

  memoize :last_comment
end
