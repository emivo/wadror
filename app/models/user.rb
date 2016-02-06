class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password
  PASSWORD_FORMAT = /\A(?=.{4,})(?=.*\d)(?=.*[A-Z])/x

  validates :password, presence: true,
            length: {:minimum => 4},
            format: {with: PASSWORD_FORMAT}
  validates :username, uniqueness: true,
            length: {minimum: 3,
                     maximum: 15}


  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
end
