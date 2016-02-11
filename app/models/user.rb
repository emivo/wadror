class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :password, length: {minimum: 4},
            format: {
                with: /\d.*[A-Z]|[A-Z].*\d/,
                message: "has to contain one number and one upper case letter"
            }
  validates :username, uniqueness: true,
            length: {minimum: 3,
                     maximum: 15}


  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    Hash[ratings.joins(:beer).group(:style).average(:score).sort].first[0]
  end

  def favorite_brewery
    return nil if ratings.empty?
    query = ratings.joins(:beer).joins("INNER JOIN breweries").where("beers.brewery_id = breweries.id").group("breweries.id").average(:score)
    brewery_id = Hash[query.sort_by {|id,value| value}.reverse].first[0]
    Brewery.find(brewery_id)
  end
end
