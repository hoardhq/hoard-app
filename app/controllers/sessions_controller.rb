class SessionsController < ApplicationController

  layout 'unauthenticated'

  def new
    params[:user] ||= {}
    @user = User.new(email: params[:user][:email])
  end

  def create
    context = AuthenticateUser.call(params: params.require(:user), request_ip: request.ip)
    if context.failure?
      flash[:error] = context.error
      redirect_to new_session_path(user: { email: params[:user][:email] })
      return
    end
    session[:user_id] = context.user.id
    flash[:success] = "You are now signed in"
    redirect_to root_path
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_session_path
  end
end
