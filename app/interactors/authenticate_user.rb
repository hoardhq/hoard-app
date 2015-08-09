class AuthenticateUser

  include Interactor

  def call
    context.user = User.find_by(email: context.params[:email])
    unless context.user && context.user.password_is?(context.params[:password])
      context.fail! error: "Invalid email or password"
    end
    User.record_timestamps = false
    context.user.update_columns(
      last_signed_in_ip: context.request_ip,
      last_signed_in_at: DateTime.now,
    )
    User.record_timestamps = true
  end

end
