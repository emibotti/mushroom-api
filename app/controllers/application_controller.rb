class ApplicationController < ActionController::API
  before_action :set_current_organization

  private

  def set_current_organization
    Organization.current_id = current_user.organization_id if user_signed_in?
  end
end
