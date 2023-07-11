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

  def join_organization
    if valid_invitation_code?(params[:invitation_code])
      current_user.organization = Organization.find_by(invitation_code: params[:invitation_code])
      current_user.save!
      render json: { message: "Joined organization successfully"}, status: :ok
    else
      render json: { message: "Invalid invitation code" }, status: :unauthorized
    end
  end

  def organization_code
    organization = current_user.organization
    organization.generate_invitation_code!
    render json: { organization_code: organization.invitation_code }, status: :ok
  end

  private

  def valid_invitation_code?(invitation_code)
    organization = Organization.find_by(invitation_code: invitation_code)
    organization.present? && !organization.invitation_code_expired?
  end
end
