class Stream < ActiveRecord::Base

  validates :name, presence: true, length: 5..32
  validates :slug, presence: true, length: 5..16

  has_many :events

  def to_param
    slug
  end

end
