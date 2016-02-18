class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name
      t.string :string,
      t.string :description
      t.string :text

      t.timestamps null: false
    end
  end
end
