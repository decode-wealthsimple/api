class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :destination
      t.date :start
      t.date :end
      t.integer :style
      t.decimal :saved_amount
      t.decimal :total_amount

      t.timestamps null: false
    end
  end
end
