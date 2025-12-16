class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Compartir flash messages con Inertia
  inertia_share flash: -> {
    {
      notice: flash.notice,
      alert: flash.alert,
      error: flash[:error]
    }
  }
end
