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
    mycelium_service = MyceliumService.new(mycelium_params, current_user, params)
    mycelium_service.call
    if mycelium_service.success?
      MyceliumMailer.qr_code_email(mycelium_service.result, current_user).deliver_later
      render json: { mycelia: MyceliumSerializer.render_as_json(mycelium_service.result), message: "#{params[:quantity]} mycelia created successfully" }, status: :created
    else
      render json: { error: mycelium_service.error_details }, status: mycelium_service.error_code
    end

  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def harvest
    harvest_service = HarvestService.new(mycelium_params, current_user, params)
    harvest_service.call
    if harvest_service.success?
      MyceliumMailer.qr_code_email(harvest_service.result, current_user).deliver_later
      render json: { mycelia: MyceliumSerializer.render_as_json(harvest_service.result), message: "1 mycelium created successfully" }, status: :created
    else
      render json: { error: harvest_service.error_details }, status: harvest_service.error_code
    end
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

  def weight_required
    result = Mycelium.where(strain_source_id: params[:id], type: 'Fruit').where.not(weight: nil).exists?
    if result
      render json: { result: result, message: I18n.t('mycelium_controller.weight_required_message.success') }, status: :ok
    else
      render json: { result: result, message: I18n.t('mycelium_controller.weight_required_message.error') }, status: :ok
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def archive
    archive_service = ArchiveService.new(current_user, params)
    archive_service.call
    if archive_service.success?
      render json: { mycelium: MyceliumSerializer.render_as_json(archive_service.result), message: "Mycelium successfully archived" }, status: :ok
    else
      render json: { error: archive_service.error_details }, status: archive_service.error_code
    end

  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def ready
    mycelium = Mycelium.find(params[:id])
    mycelium.update!(ready: params[:ready])
    if params[:note].present?
      EventService.call(author_id: current_user.id, author_name: current_user.name, mycelium_id: params[:id], event_type: "inspection", note: params[:note])
    end

    render json: { ready: params[:ready] }, status: :ok

  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  private

  def mycelium_params
    params.require(:mycelium).permit(:type, :species, :strain_source_id, :generation, :external_provider, :substrate, :container, :strain_description, :shelf_time, :image_url, :weight, :prefix, :room_id)
  end
end
