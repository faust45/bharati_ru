class Collection
  attr_reader :raw, :collection, :total_rows
  delegate :each, :map, :size, :length, :to => :collection

  def initialize(resp)
    @raw = resp
    @total_rows = resp['total_rows'].to_i
    @collection = resp['rows'].map do |row|
      Audio.new(row['doc'], :directly_set_attributes => true)
    end
  end

  def inspect
    "#{self.class} #{collection.inspect}"
  end

end
