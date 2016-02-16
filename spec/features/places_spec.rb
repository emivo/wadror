require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
        [Place.new(name: "Oljenkorsi", id: 1)]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if more than one is returned by the API, they are all shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("töölö").and_return(
        [Place.new(name: "Pub 99", id: 1),
         Place.new(name: "Fellows", id: 2),
         Place.new(name: "Gringos Locos", id: 3)]
    )

    visit places_path
    fill_in('city', with: 'töölö')
    click_button "Search"

    expect(page).to have_content "Pub 99"
    expect(page).to have_content "Fellows"
    expect(page).to have_content "Gringos Locos"
  end

  it "if none is returned by the API, error message is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("lepsämä").and_return(
        []
    )

    visit places_path
    fill_in('city', with: 'lepsämä')
    click_button "Search"

    expect(page).to have_content "No locations in lepsämä"
  end
end