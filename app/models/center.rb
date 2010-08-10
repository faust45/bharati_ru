class Center < BaseModel
  use_db 'centers'
  use_rand_id

  property :name, :default => ''
  property :display_name
  property :country
  property :city
  property :address
  property :phones, :default => []
  property :fax
  property :email
  property :web
  property :description

  has_attachment :photo

  view_by :country

  search_index <<-JS
    var ret = new Document();

    if (doc.display_name) {
      ret.add(doc.display_name, {"store":"yes"});
    }

    if (doc.country) {
      ret.add(doc.country);
    }
    if (doc.city) {
      ret.add(doc.city);
    }
    if (doc.address) {
      ret.add(doc.address);
    }

    return ret;
  JS

  before_save do
    if self.display_name.blank?
      self.display_name = "#{self.name} (#{self.country}, #{self.city})"
    end
  end

  def self.load
    index = 1
    FasterCSV.foreach("/Users/faust45/Downloads/to_process.csv") do |row|
      country = row[1]

      if country and !(country =~ /Country/)
        row.map!{|el| el.strip if el }

        Center.create(:country => row[1],
                      :city    => row[2],
                      :name    => row[3],
                      :address => row[4],
                      :phones  => [row[5], row[6]].compact,
                      :fax     => row[7],
                      :email   => row[8],
                      :web     => row[9]
                     )
      end

      index += 1
    end
  end
end
