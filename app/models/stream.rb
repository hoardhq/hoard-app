class Stream < ActiveRecord::Base

  validates :name, presence: true, length: 5..32
  validates :slug, presence: true, length: 5..16

  def to_param
    slug
  end

end
