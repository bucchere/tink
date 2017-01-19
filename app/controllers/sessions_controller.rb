class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroy
    current_user.update_attribute(:oauth_expires_at, Time.zone.now - 30.seconds)
    session[:user_id] = nil
    redirect_to '/auth/google_oauth2'
  end
end
