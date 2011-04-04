class Forum::Comment < Forum::Message

  property :post_id

  validates_presence_of :post_id

  def to_s
    body.gsub(/\[quote.*\[\/quote\]/m, '')
  end

  def post
    Forum::Post.get_doc!(post_id)
  end

end
