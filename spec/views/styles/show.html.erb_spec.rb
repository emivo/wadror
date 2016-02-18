require 'rails_helper'

RSpec.describe "styles/show", type: :view do
  before(:each) do
    @style = assign(:style, Style.create!(
      :name => "Name",
      :string, => "String,",
      :description => "Description",
      :text => "Text"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/String,/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Text/)
  end
end
