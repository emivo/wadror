require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:user) {FactoryGirl.create :user}
  let!(:brewery) { FactoryGirl.create :brewery, name: "Koff" }

  before :each do
    sign_in(username: "Pekka", password: "Lorem1")
  end

  it "is valid with non-empty name" do
    visit new_beer_path
    fill_in('beer[name]', with: "Bisse")
    select('Lager', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')

    expect {
      click_button "Create Beer"
    }.to change { Beer.count }.from(0).to(1)
  end

  it "is not saved with invalid name and displays error message" do
    visit new_beer_path
    fill_in('beer[name]', with: "")
    select('Koff', from: 'beer[brewery_id]')

    click_button "Create Beer"

    expect(Beer.count).to eq(0)
    expect(page).to have_content "error"
    expect(page).to have_content "Name can't be blank"
  end
end