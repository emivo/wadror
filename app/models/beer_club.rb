class BeerClub < ActiveRecord::Base
  has_many :memberships
  has_many :members, through: :memberships, source: :user

  def to_s
    "#{name}, (#{city} #{founded})"
  end
end
