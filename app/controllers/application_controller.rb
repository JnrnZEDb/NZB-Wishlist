class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    before_filter :ensure_setup

    def ensure_setup
        unless current_settings.setup_complete? || on_settings?
            flash[:warning] = "Populate your settings to complete the application setup."
            redirect_to edit_settings_path
        end
    end

    def current_settings
        @settings ||= Setting.first
    end

    private

    def success(obj)
        render json: { success: true }.merge(obj)
    end

    def failure(obj, message = nil)
        render json: { success: false, message: message }.merge(obj)
    end

    def on_settings?
        params[:controller] == "settings"
    end
end
