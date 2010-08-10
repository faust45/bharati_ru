class Tag < BaseModel

  view_by :all, :map => <<-MAP,
    function(doc) {
      if (doc.tags) {
        doc.tags.forEach(function(tag) {
          tokens = tag.split(/\s/i);

          tokens.forEach(function(token) {
            emit(token, tag);
          });
        });
      }
    }
  MAP
  :reduce => <<-REDUCE
    function(doc, values, rereduce) {
      return values;
    }
  REDUCE


  class <<self
    def like(q)
      ret = []
      result = by_all(:startkey => q, :endkey => "#{q}香", :raw => true, :reduce => true, :group => true)
      
      result['rows'].each do |row|
        ret |= row['value']
      end

      ret
    end
  end

end
