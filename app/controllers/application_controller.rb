class ApplicationController < ActionController::API
  before_action :set_current_organization, :set_locale

  private

  def set_current_organization
    Organization.current_id = current_user.organization_id if user_signed_in?
  end

  def set_locale
    accept_language = request.headers['Accept-Language']
    locale = accept_language&.split('-')&.first || I18n.default_locale
    I18n.locale = locale if I18n.available_locales.include?(locale.to_sym)
  end
end
