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
                     maximum: 39}


  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def self.top(n)
    # Parempi tehdä vain kaksi sql-kysely
    User.find(Rating.all.select(:id).order('count_all DESC').group(:user_id).limit(n).count('*').keys)
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    query = ratings.joins(:beer).order('average_score DESC').group(:style_id).average(:score)
    Style.find query.first[0]
  end

  def favorite_brewery
    return nil if ratings.empty?
    query = ratings.joins(:beer => :brewery).order('average_score DESC').group("breweries.id").average(:score)
    Brewery.find query.first[0]
  end
end
