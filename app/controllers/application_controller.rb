class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  helper_method :current_user

  def authenticate_user!
    if current_user.blank? && params[:controller] != 'sessions'
      flash[:error] = "You must sign in to do that"
      redirect_to new_session_path
    end
  end

  def current_user
    @current_user ||= begin
      if session[:user_id]
        user = User.find(session[:user_id])
        return nil unless user.present?
        session[:user_id]
      end
    end
  end
end
