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
        new_mycelium_params = @mycelium_params.merge({ name: "#{bulk_father.name + '-' + bulk_father.flush.to_s}", species: bulk_father.species, strain_description: bulk_father.species, flush: bulk_father.flush})
        new_mycelium_params[:type] = 'Fruit'
        mycelium = Mycelium.create!(new_mycelium_params)
        EventService.call(author_id: @current_user.id, author_name: @current_user.name, mycelium_id: mycelium.id, event_type: "to_#{@params[:type].downcase}", note: 'Fruit')
      end
  
      @status = :success
      @result = mycelium
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
  