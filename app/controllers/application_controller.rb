class ApplicationController < ActionController::API
  before_action :set_locale

  def set_locale
    I18n.locale = request.headers['Accept-Language'] || 'en'
  end

end
