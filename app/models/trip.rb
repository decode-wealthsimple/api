require 'rest-client'
require '../controllers/nomad_controller.rb'

class Trip < ActiveRecord::Base
  validates :origin, :destination, :start, :end, presence: true
  validates :style, inclusion: 1..3
  validates :saved_amount, :total_amount, numericality: {greater_than_or_equal_to: 0}

  def deposit(amount)
    self.saved_amount += amount
  end

  def withdraw(amount)
    self.saved_amount -= amount
  end



end
