class SessionsController < ApplicationController

  layout 'unauthenticated'

  def new
    params[:user] ||= {}
    @user = User.new(email: params[:user][:email])
  end

  def create
    params[:user] ||= {}
    @user = User.find_by(email: params[:user][:email])
    # raise "#{BCrypt::Password.new(@user.encrypted_password)} == #{params[:user][:password]}"
    if @user && @user.password_is?(params[:user][:password])
      User.record_timestamps = false
      @user.update_columns(
        last_signed_in_ip: request.ip,
        last_signed_in_at: DateTime.now,
      )
      User.record_timestamps = true
      session[:user_id] = @user.id
      flash[:success] = "You are now signed in"
      redirect_to root_path
    else
      flash[:error] = "Invalid email or password"
      redirect_to new_session_path(user: { email: params[:user][:email] })
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_session_path
  end
end
