class Collection
  attr_reader :raw, :collection
  delegate :any?, :find, :-, :+, :[], :first, :last, :to_a, :each, :map, :size, :length, :to => :collection

  def initialize(resp, klass, options = {})
    @klass = klass
    @raw_resp = resp
    @view_name = options[:view]
    @view_options = options[:view_options]
    @collection = resp['rows'].map do |row|
      klass.new(row['doc'], :directly_set_attributes => true)
    end
  end

  def total_rows
    unless @total_rows
      if @view_options.keys.find{|k| ['key', 'startkey'].include?(k.to_s)}
        @view_options[:reduce] = true
        @view_options.delete(:limit)
        @view_options.delete(:skip)

        resp = @klass.view(@view_name, @view_options)
        @total_rows = resp['rows'][0]['value']
      else
        @total_rows = @raw_resp['total_rows'].to_i
      end
    end

    @total_rows
  end

  def inspect
    "#{self.class} #{collection.inspect}   view: #{@view_name} options: #{@view_options.inspect}"
  end

end
