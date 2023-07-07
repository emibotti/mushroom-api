class OrganizationsController < ApplicationController
  def show
    @organization = Organization.find(params[:id])
    render json: @organization, status: :ok
  end

  def create
    @organization = Organization.new(name: params[:name])
    if @organization.save
      current_user.organization = @organization
      if current_user.save
        render json: @organization, status: :ok
      else
        render json: { message: "Couldnt assign org to user" }, status: :unprocessable_entity
      end
    else
      render json: { message: "Couldnt save Org" }, status: :unprocessable_entity
    end
  end
end
