class EventService < ServiceObject
  def initialize(event_params)
    @event_params = event_params
  end

  def call
    if @event_params[:id]
      update
    else
      create
    end
  end

  private

  def create
    @event = Event.new(@event_params)

    if @event.save
      @status = :success
      @result = @event
    else
      @status = :error
      @error_code = :event_creation_failed
      @error_details = @event.errors.full_messages.join(', ')
    end
  end

  def update
    @event = Event.find(@event_params[:id])

    if @event.update(@event_params)
      @status = :success
      @result = @event
    else
      @status = :error
      @result = nil
      @exceptions = @event.errors.full_messages
    end
  end
end
