class Content < BaseModel

  property :title
  property :author_id
  property :co_authors, :default => []
  property :description
  property :tags,       :default => []
  property :is_published, :default => true 
  property :slug, :read_only => true

  timestamps!

  def author
    @author ||= Author.get(self.author_id)
  end

  def set_author(author)
    self.author_id = author.id unless author.blank?
  end

end
