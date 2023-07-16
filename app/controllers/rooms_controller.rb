class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    rooms = Room.all
    render json: rooms, status: :ok
  end

  def show
    room = Room.find(params[:id])
    room_inspection = room.room_inspections.last
    render json: room_with_inspection(room, room_inspection), status: :ok
  end

  def create
    room = Room.create!(room_params)
    room_inspection = room.room_inspections.create!(room_inspection_params)
    render json: room_with_inspection(room, room_inspection), status: :ok
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

  def room_with_inspection(room, room_inspection)
    return room.as_json.merge(room_inspection.as_json(only: [:humidity, :temperature, :co_2, :notes])) if room_inspection
    room.as_json
  end
end
