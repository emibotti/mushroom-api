class MyceliumService < ServiceObject
  def initialize(mycelium_params, current_user, params)
    @mycelium_params = mycelium_params
    @current_user = current_user
    @params = params
  end

  def call
    generate_mycelia
  end

  private

  def generate_mycelia
    generation = @mycelium_params[:generation].to_i
    species = @mycelium_params[:species]
    strain_description = @mycelium_params[:strain_description]

    # Inoculation
    if @mycelium_params[:strain_source_id].present?
      mycelium_father = Mycelium.find(@mycelium_params[:strain_source_id])

      generation = mycelium_father.generation
      generation += 1 if mycelium_father.type == @mycelium_params[:type]

      species = mycelium_father.species
      # TODO: Validate if this value is going to change along inoculations
      strain_description = mycelium_father.strain_description
    end

    prefix = @mycelium_params[:prefix]
    # TODO: Check that the quantity field is not null
    quantity = @params[:quantity].to_i
    generated_mycelia = []

    ActiveRecord::Base.transaction do
      prefix_count = PrefixCount.find_or_create_by!(prefix: prefix, organization_id: @current_user.organization_id)
      start_count = prefix_count.count + 1
      prefix_count.increment!(:count, quantity)

      quantity.times do |i|
        name = "#{prefix}-#{start_count + i}"
        @mycelium_params[:flush] = 0 if @mycelium_params[:type] == 'Bulk'
        mycelium = Mycelium.create!(name: name, **@mycelium_params, generation: generation, species: species, strain_description: strain_description)
        EventService.call(author_id: @current_user.id, author_name: @current_user.name, mycelium_id: mycelium.id, event_type: "to_#{@params[:type].downcase}", note: mycelium.name)

        # Hacer log de cambio de cuarto si viene el param en la creación.. hacerlo con `if`
        # EventService.call(author_id: @current_user.id, author_name: @current_user.name, mycelium_id: mycelium.id, event_type: "room_change", note: @params[:])

        if @params[:note].present?
          EventService.call(author_id: @current_user.id, author_name: @current_user.name, mycelium_id: mycelium.id, event_type: "inspection", note: @params[:note])
        end

        generated_mycelia.push mycelium
      end
    end

    # Set the service status and result
    @status = :success
    @result = generated_mycelia
  rescue ActiveRecord::RecordInvalid => e
    @status = :error
    @error_code = :unprocessable_entity
    @error_details = e.message
  rescue ActiveRecord::RecordNotFound => e
    @status = :error
    @error_code = :not_found
    @error_details = e.message
  end
end
