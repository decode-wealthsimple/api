class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.integer :origin_id
      t.integer :destination_id
      t.date :start
      t.date :end
      t.integer :style
      t.decimal :saved_amount
      t.decimal :total_amount

      t.timestamps null: false
    end
  end
end
