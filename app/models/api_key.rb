class ApiKey < ActiveRecord::Base

  before_validation :generate_key

  def generate_key
    self.key ||= SecureRandom.hex(16)
  end
end
