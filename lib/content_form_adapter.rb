class ContentFormAdapter < FormAdapter
  attr_reader :content

  Types = { 
   'lecture' => 'Лекция',
   'seminar' => 'Семинар',
   'appeal'  => 'Обрашение',
   'kirtan'  => 'Киртан',
   'music'   => 'Музыка'
  }


  def initialize(content, params = {})
    @content = content
  end

  def author_id
    author[:id]
  end

  def author_name
    author[:name]
  end
  alias :author_value :author_name 

  def record_place_id
    content.record_place[:id]
  end

  def record_place_name
    content.record_place[:name]
  end
  alias :record_place_value :record_place_name

end
