class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    rooms = Room.all
    render json: RoomSerializer.render(rooms), status: :ok
  end

  def show
    room = Room.find(params[:id])
    render json: RoomSerializer.render(room, view: :show), status: :ok
  end

  def create
    room = Room.create!(room_params)
    room_inspection = room.room_inspections.create!(room_inspection_params)
    render json: RoomSerializer.render(room, view: :show), status: :ok
  rescue ActiveRecord::RecordInvalid => invalid
    render json: { message: invalid.record.errors.full_messages.first }, status: :unprocessable_entity
  end

  def create_inspection
    room = Room.find(params[:id])
    room_inspection = room.room_inspections.create!(room_inspection_params)
    render json: room_inspection, status: :ok
  rescue ActiveRecord::RecordInvalid => invalid
    render json: { message: invalid.record.errors.full_messages.first }, status: :unprocessable_entity
  end

  private

  def room_params
    params.permit(:name)
  end

  def room_inspection_params
    params.permit(:humidity, :temperature, :co_2, :notes)
  end
end
