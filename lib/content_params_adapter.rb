class ContentParamsAdapter < Hash
  attr_reader :params
  delegate :delete, :inspect, :keys, :values, :[], :each, :map, :to => :params

  FILTERED_ATTRS = %w(is_published record_place author tags categories)
  DATE_ATTRS = %w(record_date)

  def initialize(params)
    @params = params.dup
    @albums = @params.delete(:albums) || []

    fetch_params
  end

  def []=(key, value)
    send("#{key}=", value)
  end

  def albums
    @albums.map do |id|
      Album.get(id)
    end
  end

  private
    def uploader=(user)
      if user.is_a?(User)
        params[:uploaded_by_id] = user.id
      end
    end

    def author=(id)
      author = Author.get(id)

      if author
        params[:author] = {}
        params[:author][:name] = author.display_name
        params[:author][:id] = author.id
      end
    end

    def record_place=(id)
      place = Center.get(id)

      if place 
        params[:record_place] = {}
        params[:record_place][:name] = place.display_name
        params[:record_place][:id]   = place.id
      end
    end

    def is_published=(value) 
      params[:is_published] = value == '1' ? true : false
    end

    def tags=(tags)
      params[:tags] = Array(tags).uniq.reject(&:blank?)
    end

    def categories=(categories)
      params[:categories] = Array(categories).uniq
    end

    def fetch_params
      unless params.blank?
        DATE_ATTRS.each do |attr|
          date = fetch_date(attr)
          params[attr] = date if date
        end

        FILTERED_ATTRS.each do |attr|
          value = params.delete(attr)
          send("#{attr}=", value)
        end
      end
    end

    def fetch_date(field)
      date = []

      3.times{|i| date << params.delete("#{field}(#{i+1}i)").to_i }
      date.reject!(&:zero?)

      Date.new(*date) unless date.blank?
    end

end
