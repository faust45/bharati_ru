class Content < BaseModel
  use_rand_id

  property :title
  property :content_type
  property :author, :type => HHash, :default => HHash.new #name id
  property :co_authors, :default => []
  property :description
  property :tags,       :default => []
  property :categories, :default => []
  property :is_published, :default => false
  property :slug, :read_only => true
  property :upladed_by_id

  timestamps!

  view_by :title

  def set_author(author)
    unless author.blank?
      self.author[:id]   = author.id
      self.author[:name] = author.display_name
    end
  end

end
