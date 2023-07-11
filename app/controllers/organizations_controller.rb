class OrganizationsController < ApplicationController
  before_action :authenticate_user!

  def show
    organization = Organization.find(params[:id])
    render json: organization, status: :ok
  end

  def create
    organization = Organization.create!(name: params[:name])
    current_user.organization = organization
    if current_user.save
      render json: organization, status: :ok
    else
      render json: { message: "Couldnt assign org to user" }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => invalid
    render json: { message: invalid.record.errors.full_messages.first }, status: :unprocessable_entity
  end
end
