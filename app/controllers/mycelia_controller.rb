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
    generation = mycelium_params[:generation].to_i
    # Inoculation
    if mycelium_params[:strain_source_id]
      mycelium_father = Mycelium.find(mycelium_params[:strain_source_id])
      generation = mycelium_father.generation
      generation += 1 if mycelium_father.type === mycelium_params[:type]
    end

    prefix = mycelium_params[:prefix]
    quantity = params[:quantity].to_i

    ActiveRecord::Base.transaction do
      prefix_count = PrefixCount.find_or_create_by!(prefix: prefix, organization_id: current_user.organization_id)
      start_count = prefix_count.count + 1
      prefix_count.increment!(:count, quantity)

      quantity.times do |i|
        Mycelium.create!(name: "#{prefix}-#{start_count + i}", generation: generation, inoculation_date: Time.now, **mycelium_params)
      end
    end

    render json: { message: "#{quantity} mycelia created successfully" }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
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
    params.require(:mycelium).permit(:type, :species, :strain_source_id, :generation, :external_provider, :substrate, :container, :strain_description, :shelf_time, :image_url, :weight, :prefix)
  end
end
