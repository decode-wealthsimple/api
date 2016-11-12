class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.belongs_to :trip, index: true
      t.string :name
      t.string :country
      t.string :airport
      t.string :url

      t.timestamps null: false
    end
  end
end
