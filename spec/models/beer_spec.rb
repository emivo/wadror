require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved with name and style" do
    style = Style.create name: "Lager"
    beer = Beer.create name: "Aura", style_id: style.id

    expect(beer.name).to eq("Aura")
    expect(beer.style).to eq(style)

    expect(Beer.count).to eq(1)
    expect(Beer.first).to eq(beer)
  end

  it "is not saved without valid name" do
    style = Style.create name: "bisse"
    beer = Beer.create style_id: style.id

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without style" do
    beer = Beer.create name:"Bisse"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
