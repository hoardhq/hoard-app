class Stream < ActiveRecord::Base

  validates :name, presence: true, length: 5..32
  validates :slug, presence: true, length: 5..16

  has_many :events
  has_many :query_results
  has_many :queries, through: :query_results

  def to_param
    slug
  end

end
