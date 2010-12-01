class Event < BaseModel
  use_time_id

  TYPES = {
    "public_meet_up" => "Публичные встречи",
    "web_conf" => "Интернет-конференции",
    "maharadj" => "Деятельность Махараджа",
    "projects" => "Ваше участие в проектах",
    "novelty"  => "Новинки"
  }

  property :title
  property :description
  property :short_description
  property :event_type
  property :start_date
  property :start_time
  property :end_date
  property :end_time
  property :phone
  property :mail
  property :main_photo
  property :main_photo_horizontal

  class<< self
    def get_all(options = {})
      view_docs('events_all', options)
    end

    def get_main
      db = database
      doc = db.get('events_main_album', :include_docs => true)
      resp = db.documents(:keys => doc['events'] || [], :include_docs => true)
      Collection.new resp, self 
    end

    def get_news
      db = database
      doc = db.get('events_main_album', :include_docs => true)
      resp = db.documents(:keys => doc['news'] || [], :include_docs => true)
      Collection.new resp, self 
    end


    def get_actual(options = {})
      now = Time.now
      type = options.delete(:type) || 'any'

      options[:startkey] = [type, now.to_s(:db)]
      options[:endkey] = [type, {}]

      view_docs('events_by_type_and_end_date_time', options)
    end

    def get_not_actual(options = {})
      now = Time.now
      type = options.delete(:type) || 'any'

      options[:startkey] = [type, nil]
      options[:endkey] = [type, now.to_s(:db)]

      view_docs('events_by_type_and_end_date_time', options)
    end

    def types
      TYPES.map do |k, v|
        {:id => k, :title => v}
      end
    end
  end


  def event_type_human 
    TYPES[event_type]
  end
end
