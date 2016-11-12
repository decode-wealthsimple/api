class AddOriginToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :origin, :string
  end
end
