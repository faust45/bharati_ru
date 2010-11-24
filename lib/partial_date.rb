class PartialDate

  def initialize(value)
    @date =
    case value
      when String
        value
      when Date
        value.to_s(:db)
      when Time 
        value.to_date.to_s(:db)
      when PartialDate
        value.to_s
    end
  end


  class<< self
    def parse_ru(str)
      date = Date.parse_ru(str)
      PartialDate.new(date)
    end
  end

  def to_date
    Date.new(*parts)
  end

  def year
    parts[0]
  end

  def month
    parts[1]
  end

  def day
    parts[2]
  end

  def parts
    a = to_s.split('-')
    a.map!(&:to_i)
  end

  def to_s
    @date
  end

  def to_json
    to_s.to_json
  end

end
