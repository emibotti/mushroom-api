class HarvestService < ServiceObject
    def initialize(mycelium_params, current_user, params)
      @mycelium_params = mycelium_params
      @current_user = current_user
      @params = params
    end
  
    def call
      harvest
    end
  
    private
  
    def harvest
      bulk_father = Mycelium.find(@mycelium_params[:strain_source_id])
      mycelium = nil
      ActiveRecord::Base.transaction do
        bulk_father.increment!(:flush)
        prefix_count = PrefixCount.find_or_create_by!(prefix: bulk_father.name, organization_id: @current_user.organization_id)
        start_count = prefix_count.count + 1
        prefix_count.increment!(:count)
        prefix = bulk_father.name
        new_mycelium_params = @mycelium_params.merge({ name: "#{prefix + '-' + start_count.to_s}", species: bulk_father.species,
                                                       strain_description: bulk_father.strain_description, flush: bulk_father.flush,
                                                       container: bulk_father.container, substrate: bulk_father.substrate,
                                                       generation: bulk_father.generation, prefix: prefix })
        new_mycelium_params[:type] = 'Fruit'
        mycelium = Mycelium.create!(new_mycelium_params)
        EventService.call(author_id: @current_user.id, author_name: @current_user.name, mycelium_id: mycelium.id, event_type: "to_fruit", note: mycelium.name)

        if @params[:note].present?
          EventService.call(author_id: @current_user.id, author_name: @current_user.name, mycelium_id: mycelium.id, event_type: "inspection", note: @params[:note])
        end
      end
  
      @status = :success
      @result = [mycelium]
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
  