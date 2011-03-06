class Forum::Post < Forum::Message

  property :title

  validates_presence_of :title

  class <<self
    def stat
      h = {}
      comments = view('forum_comments', :reduce => true,
                                        :group => true,
                                        :startkey => ['ForumPost'],
                                        :endkey => ['ForumPost', {}])
      comments['rows'].each do |r|
        h[r['key'][1]] = r['value']
      end

      h
    end
  end

  def to_s
    body 
  end

  def <<(comment)
    raise "Could't add comment to not saved post" if self.new?

    comment.post_id  = self.id
    comment.topic_id = self.topic_id
    comment.save
  end

  def comments
    Forum::Comment.view_docs('comments_by_post_id', :key => self.id)
  end

  def last_comment
    @last_comment ||= Forum::Comment.view_docs('comments_by_post_id', :key => self.id, :descending => true, :limit => 1).first
  end

end
