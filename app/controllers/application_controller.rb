class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorize
    redirect_to '/auth/google_oauth2' unless current_user && Rails.application.config.user_whitelist.include?(current_user.uid)
  end
end
