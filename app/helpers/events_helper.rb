module EventsHelper
  def event_types
    Event.types
  end

  def d(text)
    text.gsub(/(http.+?)\s*\[(.*?)\]/) do
      link_to($2, $1, :target => '_blank')
    end
  end
end
