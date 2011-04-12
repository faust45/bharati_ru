class Seo < BaseModel

  property :title
  property :description
  property :keywords

  def to_hash
    h = {}
    h[:title] = title unless title.blank?
    h[:description] = description unless description.blank?
    h[:keywords] = keywords unless keywords.blank?

    h
  end

end
