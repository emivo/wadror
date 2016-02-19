class AddStylesToBeers < ActiveRecord::Migration
  def change
    add_column :beers, :style_id, :integer
    beers = Beer.all
    for beer in beers
      style = Style.find_by_name beer.style
      if (style.nil?)
        style = Style.create name: beer.style
      end
        beer.style_id = style.id
        beer.save
    end
    remove_column :beers, :style
  end
end
