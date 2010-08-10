class Category < BaseModel

  property :name
  property :slug

  before_save :check_uniq

  def check_uniq
    raise 'shalom'
  end

end

