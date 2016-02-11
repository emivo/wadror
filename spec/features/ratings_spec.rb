require 'rails_helper'

include Helpers


describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name: "iso 3", brewery: brewery }
  let!(:beer2) { FactoryGirl.create :beer, name: "Karhu", brewery: brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Lorem1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect {
      click_button "Create Rating"
    }.to change { Rating.count }.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "is shown in ratings page, when there are ratings" do
    create_two_ratings_for_pekka
    user.ratings << FactoryGirl.create(:rating, score: 20, beer: beer2)

    visit ratings_path

    expect(page).to have_content "List of ratings"
    expect(page).to have_content "iso 3 20 Pekka"
    expect(page).to have_content "Karhu 10 Pekka"
    expect(page).to have_content "Karhu 20 Pekka"
    expect(page).to have_content "Number of ratings: 3"
  end

  it "is shown in raters page, when there are ratings" do
    create_two_ratings_for_pekka
    user2 = FactoryGirl.create(:user, username: "Kalle")
    user2.ratings << FactoryGirl.create(:rating, score: 50, beer: beer2)

    visit user_path(user)

    expect(page).to have_content "has made 2 ratings"
    expect(page).to have_content "iso 3 20"
    expect(page).to have_content "Karhu 10"
    expect(page).not_to have_content "Karhu 50"
    visit user_path(user2)

    expect(page).to have_content "has made 1 rating"
    expect(page).not_to have_content "iso 3 20"
    expect(page).not_to have_content "Karhu 10"
    expect(page).to have_content "Karhu 50"
  end

  it "is removed from user when rating is deleted" do
    create_two_ratings_for_pekka

    visit user_path(user)
    expect {
      find('li', :text => 'Karhu').click_link('delete')

    }.to change { Rating.count }.from(2).to(1)

    expect(page).to have_content "iso 3 20"
    expect(page).not_to have_content "Karhu 10"
  end

  it "when given by user, user has favorites" do
    visit user_path(user)

    expect(page).to have_content "has not favorite beer"
    expect(page).to have_content "has not favorite style"
    expect(page).to have_content "has not favorite brewery"

    create_two_ratings_for_pekka

    visit user_path(user)
    expect(page).to have_content "favorite beer iso 3"
    expect(page).to have_content "favorite style lager"
    expect(page).to have_content "favorite brewery anonymous"
  end

end

def create_two_ratings_for_pekka
  create_beer_with_rating_with_different_names(user, 20, "iso 3")
  create_beer_with_rating_with_different_names(user, 10, "Karhu")
end
