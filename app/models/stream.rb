class Stream < ActiveRecord::Base

  validates :name, presence: true, length: 5..32
  validates :slug, presence: true, length: 5..32

  has_many :events
  has_many :importers

  def to_param
    slug
  end

end
