class Trip < ActiveRecord::Base
  validates :destination, :start, :end, presence: true
  validates :style, inclusion: 1..3
  validates :saved_amount, :total_amount, numericality: greater_than_or_equal_to: 0

  def estimate
    # fancy calculations
  end

  def deposit(amount)
    self.saved_amount += amount
  end

  def withdraw(amount)
    self.saved_amount -= amount
  end

end
