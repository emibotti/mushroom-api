class ApplicationController < ActionController::API
  before_action :set_current_organization, :set_locale

  private

  def set_current_organization
    Organization.current_id = current_user.organization_id if user_signed_in?
  end

  def set_locale
    I18n.locale = request.headers['Accept-Language'] || I18n.default_locale
  end
end
