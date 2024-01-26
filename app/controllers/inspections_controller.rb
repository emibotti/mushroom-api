class InspectionsController < ApplicationController
  before_action :authenticate_user!

  def index
    events = Event.get_history(params[:mycelium_id])
    render json: EventSerializer.render_as_json(events)
  end

  def show
    event = Event.find(params[:id])
    render json: EventSerializer.render_as_json(event)
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def create
    event_service = EventService.call(event_params_with_author)

    if event_service.success?
      render json: EventSerializer.render_as_json(event_service.result), status: :ok
    else
      render json: { error: event_service.error_details }, status: :unprocessable_entity
    end
  end

  def update
    event_service = EventService.call(event_params_with_id)

    if event_service.success?
      render json: EventSerializer.render_as_json(event_service.result), status: :created
    else
      render json: { error: event_service.error_details }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  private

  def event_params
    params.require(:inspection).permit(:note)
  end

  def event_params_with_common
    { mycelium_id: params[:mycelium_id], event_type: 'inspection' }.merge(event_params)
  end

  def event_params_with_author
    author_id = current_user.id
    author_name = current_user.name

    event_params_with_common.merge(author_id: author_id, author_name: author_name)
  end

  def event_params_with_id
    event_params_with_common.merge(id: params[:id])
  end
end
