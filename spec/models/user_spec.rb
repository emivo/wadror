require 'rails_helper'

include Helpers


RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved with wrong format password" do
    user = User.create username: "Kovaluu", password: "pelkkiapienia", password_confirmation: "pelkkiapienia"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with too short password" do
    user = User.create username: "Lorem", password: "ips", password_confirmation: "ips"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user) { FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(user, 10, 15, 7, 9, 3)
      best = create_beer_with_rating(user, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without rating does not have favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest average of ratings if several rated" do
      create_beers_with_ratings(user, 10, 15, 7)

      style = FactoryGirl.create(:style, name: "ipa", description: "perus ipa")
      beer = FactoryGirl.create(:beer, style: style)
      FactoryGirl.create(:rating, score: 50, beer: beer, user: user)

      expect(user.favorite_style).to eq(style)
    end
  end

  describe "favorite brewery" do
    let(:user) { FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without rating does not have favorite brewery" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated" do
      beer = create_beer_with_rating(user, 20)
      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the one with highest average of ratings if several rated" do
      create_beers_with_ratings(user, 10, 2, 5)

      brewery = FactoryGirl.create(:brewery, name: "Koff")
      beer = FactoryGirl.create(:beer, brewery: brewery)
      FactoryGirl.create(:rating, score: 40, beer: beer, user: user)

      expect(user.favorite_brewery).to eq(brewery)
    end
  end
end



