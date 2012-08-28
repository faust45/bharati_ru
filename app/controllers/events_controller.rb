class EventsController < ApplicationController
  free_actions :index, :show, :type

  def index
    @actual_events = Event.get_actual
    @not_actual_events = Event.get_not_actual

    @page_title = "События"
  end

  def type
    @type = params[:type]
    @actual_events = Event.get_actual(:type => params[:type])
    @not_actual_events = Event.get_not_actual(:type => params[:type], :descending => true)


    @page_title = ["События", Event::TYPES[@type]]
    render :index
  end

  def show
    @event = Event.get_doc!(params[:id])
    @type = @event.event_type

    @page_title = ["События", @event.event_type_human, @event.to_s]
    @page_description = @event.description
  end

end
