class Content < BaseModel
  use_rand_id

  property :title
  property :author, :type => HHash, :default => HHash.new #name id
  property :co_authors, :default => []
  property :description
  property :tags,       :default => []
  property :categories, :default => []
  property :is_published, :default => true 
  property :slug, :read_only => true
  property :upladed_by_id

  timestamps!


  def set_author(author)
    unless author.blank?
      unless author.new?
        self.author[:id]   = author.id
        self.author[:name] = author.display_name
      end
    end
  end

end
