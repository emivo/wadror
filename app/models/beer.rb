class Beer < ActiveRecord::Base
  include RatingAverage
  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  validates :name, allow_blank:  false
  def to_s
    "#{self.name}, #{self.brewery.name}"
  end
end
