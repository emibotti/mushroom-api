# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  include RackSessionFix
  respond_to :json

  def create
    super do |user|
      user.name = params[:user][:name]
      user.save
    end
  end

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        message: 'Signed up sucessfully.',
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
      }, status: :unprocessable_entity
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :name])
  end
end
