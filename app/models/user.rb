require 'bcrypt'

class User < ActiveRecord::Base

  include BCrypt

  def password
  end

  def password=(new_password)
    @password = Password.create(new_password, cost: 13)
    self.encrypted_password = @password
  end

  def password_is?(attempted_password)
    Password.new(encrypted_password) == attempted_password
  end

end
