require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved with name and style" do
    beer = Beer.create name: "Aura", style:"Lager"

    expect(beer.name).to eq("Aura")
    expect(beer.style).to eq("Lager")

    expect(Beer.count).to eq(1)
    expect(Beer.first).to eq(beer)
  end

  it "is not saved without valid name" do
    beer = Beer.create style:"bisse"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without style" do
    beer = Beer.create name:"Bisse"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
