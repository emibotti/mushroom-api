class MyceliaController < ApplicationController
  before_action :authenticate_user!

  def index
    mycelia = Mycelium.all
    render json: mycelia, satus: :ok
  end

  def show
    mycelium = Mycelium.find(params[:id])
    render json: mycelium, status: :ok
  end

  def create
    mycelium = Mycelium.create!(mycelium_params)
    render json: mycelium, status: :ok
  rescue ActiveRecord::RecordInvalid => invalid
    render json: { message: invalid.record.errors.full_messages.first }, status: :unprocessable_entity
  end

  def update
    mycelium = Mycelium.find(params[:id])
    mycelium.update!(mycelium_params)
    render json: mycelium, status: :ok
  rescue ActiveRecord::RecordInvalid => invalid
    render json: { message: invalid.record.errors.full_messages.first }, status: :unprocessable_entity
  end

  def destroy
    mycelium = Mycelium.find(params[:id])
    mycelium.destroy
    head :no_content
  end

  private

  def mycelium_params
    params.permit(:name, :type, :species, :inoculation_date, :strain_source_id, :generation, :external_provider, :substrate, :container, :strain_description, :shelf_time, :image_url, :weight, :prefix)
  end
end
