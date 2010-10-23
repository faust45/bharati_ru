class Array
  def highlight(str)
    map {|item| item.highlight(str)} 
  end
end

class String
  def highlight(str)
    is_hit = false
    r = Regexp.new(str.mb_chars.downcase, Regexp::IGNORECASE | Regexp::MULTILINE) 
    buff = self.mb_chars.downcase.gsub(r) do |m|
      is_hit = true
      "<span class='red'>#{m}</span>"
    end

    if is_hit
      def buff.is_highlight?; true end
    else
      def buff.is_highlight?; false end
    end

    buff
  end
end
