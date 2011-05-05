class AudioBookTrack < BaseModel

  property :title
  property :source, HHash
  property :duration
  property :main_photo
  property :keywords, [], :default => []
  property :description

  def to_s
    title
  end

end
