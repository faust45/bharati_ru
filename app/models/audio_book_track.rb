class AudioBookTrack < BaseModel

  property :title
  property :source, HHash
  property :duration
  property :main_photo

  def to_s
    title
  end

end
