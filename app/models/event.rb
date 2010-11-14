class Event < BaseModel
  use_time_id

  TYPES = {
    "public_meet_up" => "Публичные встречи",
    "web_conf" => "Интернет-конференции",
    "maharadj" => "Деятельность Махараджа",
    "projects" => "Проекты и участие в них",
    "novelty"  => "Новинки"
  }

  property :title
  property :description
  property :event_type
  property :start_date
  property :start_time
  property :end_date
  property :end_time
  property :phone
  property :mail
  property :main_photo

  class<< self
    def get_all(options = {})
      view_docs('events_all', options)
    end

    def get_actual(options = {})
      now = Time.now
      options[:startkey] = now.to_s(:db)
      options[:endkey] = {}

      view_docs('events_by_end_date_time', options)
    end

    def get_not_actual(options = {})
      now = Time.now
      options[:startkey] = nil 
      options[:endkey] = now.to_s(:db)

      view_docs('events_by_end_date_time', options)
    end

    def get_actual_by_type(event_type, options = {})
      now = Time.now
      options[:startkey] = [event_type, now.to_s(:db)]
      options[:endkey] = [event_type, {}]

      view_docs('events_by_type_and_end_date_time', options)
    end

    def get_not_actual_by_type(event_type, options = {})
      now = Time.now
      options[:startkey] = [event_type, nil]
      options[:endkey] = [event_type, now.to_s(:db)]

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
