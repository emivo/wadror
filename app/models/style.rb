class Style < ActiveRecord::Base
  include RatingAverage
  has_many :ratings, through: :beers
  has_many :beers, dependent: :destroy

  def self.top(n)
    Style.find(Rating.joins(:beer => :style).order('average_score DESC').limit(n).group(:style_id).average(:score).keys).sort_by{ |s| -(s.average_rating||0) }
  end

  def to_s
    self.name
  end
end
