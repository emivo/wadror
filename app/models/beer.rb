class Beer < ActiveRecord::Base
  include RatingAverage
  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style_id, presence: true

  def self.top(n)
    Beer.find(Rating.order('average_score DESC').limit(n).group(:beer_id).average(:score).keys).sort_by{ |b| -(b.average_rating||0)}
  end

  def to_s
    "#{self.name}, #{self.brewery.name}"
  end
end
