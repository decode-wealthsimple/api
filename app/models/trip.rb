require 'rest-client'

class Trip < ActiveRecord::Base
  belongs_to :origin, class_name: 'City', foreign_key: 'origin_id'
  belongs_to :destination, class_name: 'City', foreign_key: 'destination_id'

  validates :origin_id, :destination_id, :start, :end, presence: true
  validates :style, inclusion: 1..3
  validates :saved_amount, :total_amount, numericality: {greater_than_or_equal_to: 0}

  def deposit(amount)
    self.saved_amount += amount
  end

  def withdraw(amount)
    self.saved_amount -= amount
  end



end
