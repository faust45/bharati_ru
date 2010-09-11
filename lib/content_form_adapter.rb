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

  def author_value
    author.display_name
  end

end
