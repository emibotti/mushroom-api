class MyceliaController < ApplicationController
  before_action :authenticate_user!

  def index
    mycelia = Mycelium.all
    render json: MyceliumSerializer.render(mycelia, view: :card), status: :ok
  end

  def show
    mycelium = Mycelium.find(params[:id])
    render json: MyceliumSerializer.render(mycelium, view: :show), status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def create
    generation = mycelium_params[:generation].to_i
    # Inoculation
    if mycelium_params[:strain_source_id].present?
      mycelium_father = Mycelium.find(mycelium_params[:strain_source_id])

      generation = mycelium_father.generation
      generation += 1 if mycelium_father.type === mycelium_params[:type]
    end

    prefix = mycelium_params[:prefix]
    quantity = params[:quantity].to_i
    generated_mycelia = []

    ActiveRecord::Base.transaction do
      prefix_count = PrefixCount.find_or_create_by!(prefix: prefix, organization_id: current_user.organization_id)
      start_count = prefix_count.count + 1
      prefix_count.increment!(:count, quantity)

      quantity.times do |i|
        name = "#{prefix}-#{start_count + i}"        
        mycelium = Mycelium.create!(name: name, inoculation_date: Time.now, **mycelium_params, generation: generation)
        EventService.call({ author_id: current_user.id,
                            author_name: current_user.name,
                            mycelium_id: mycelium.id,
                            event_type: "to_#{params[:type].downcase}",
                            note: "#{mycelium.name}" })
        if params[:note]
           EventService.call({ author_id: current_user.id,
                               author_name: current_user.name,
                               mycelium_id: mycelium.id,
                               event_type: "inspection",
                               note: params[:note] })
        end
        generated_mycelia.push mycelium
      end
    end

    MyceliumMailer.qr_code_email(generated_mycelia, current_user).deliver_later

    render json: { mycelia: MyceliumSerializer.render_as_json(generated_mycelia), message: "#{quantity} mycelia created successfully" }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def update
    mycelium = Mycelium.find(params[:id])
    mycelium.update!(mycelium_params)
    render json: mycelium, status: :ok
  rescue ActiveRecord::RecordInvalid => invalid
    render json: { message: invalid.record.errors.full_messages.first }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def destroy
    mycelium = Mycelium.find(params[:id])
    mycelium.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def options
    species_options = Mycelium.species.keys.map do |key|
      { translated_label: I18n.t("mycelium.species.#{key}"), value: key }
    end

    substrate_options = Mycelium.substrates.keys.map do |key|
      { translated_label: I18n.t("mycelium.substrates.#{key}"), value: key }
    end

    container_options = Mycelium.containers.keys.map do |key|
      { translated_label: I18n.t("mycelium.containers.#{key}"), value: key }
    end

    render json: { species: species_options, substrates: substrate_options, containers: container_options }
  end

  private

  def mycelium_params
    params.require(:mycelium).permit(:type, :species, :strain_source_id, :generation, :external_provider, :substrate, :container, :strain_description, :shelf_time, :image_url, :weight, :prefix, :room_id)
  end
end
