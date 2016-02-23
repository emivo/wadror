module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    self.ratings.average(:score).round(1) if !self.ratings.average(:score).nil?
  end
end
