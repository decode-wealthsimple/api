class City < ActiveRecord::Base
  has_many :trips

  validates :name, :country, :airport, :url, presence: true
end
