class Brewery < ActiveRecord::Base
  include RatingAverage
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, allow_blank: false
  validates :year, numericality: {greater_than_or_equal_to: 1042,
                                  less_than_or_equal_to: Date.today.year,
                                  only_integer: true}

  def print_report
    puts name
    puts "established at year #{self.year}"
    puts "number of beers #{self.beers.count}"
  end


  def restart
    self.year = 2016
    puts "changed year to #{year}"
  end
end
