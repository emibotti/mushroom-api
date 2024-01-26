class ArchiveService < ServiceObject
    def initialize(mycelium_params, current_user, params)
      @mycelium_params = mycelium_params
      @current_user = current_user
      @params = params
    end
  
    def call
      archive
    end
  
    private
  
    def archive
      mycelium = Mycelium.where(id: @mycelium_params[:id])
      mycelium.archived = @params[:archived]
      mycelium.save!

      EventService.call(author_id: @current_user.id, author_name: @current_user.name, mycelium_id: mycelium.id, event_type: @params[:archived])

      if @params[:note].present?
        EventService.call(author_id: @current_user.id, author_name: @current_user.name, mycelium_id: mycelium.id, event_type: "inspection", note: "#{I18n.t("archive_service.#{@params[:archived]}")}" + ':'+ " #{@params[:note]}")
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
  