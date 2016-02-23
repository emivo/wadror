class Style < ActiveRecord::Base
  include RatingAverage
  has_many :ratings, through: :beers
  has_many :beers, dependent: :destroy

  def self.top(n)
    Style.all.sort_by{ |s| -(s.average_rating||0) }.take(n)
  end

  def to_s
    self.name
  end
end
