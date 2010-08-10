class MediaContent < Content
  
  property :record_place, :type => HHash, :default => HHash.new
  property :record_date,  :type => Date

end
