class Forum::Message < BaseModel 
  use_time_id

  property :author_id
  property :topic_id
  property :body
  property :created_at

  validates_presence_of :author_id
  validates_presence_of :topic_id
  validates_presence_of :body

  def author
    if author_id
      @author ||= User.get(author_id)
    end
  end

  def author_display_name
    author.try(:login)
  end

  def quotes
    quotes = []
    m = body.match(/\[quote.*\[\/quote\]/m)
    m[0]
  end

end
