class Importer < ActiveRecord::Base

  validates :endpoint, presence: true
  validates :provider, inclusion: { in: %w(logentries) }
  validates :schedule, numericality: { only_integer: true, greater_than_or_equal_to: 60 }
  validates :stream, presence: true

  belongs_to :stream

end
