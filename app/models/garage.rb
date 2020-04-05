class Garage < ApplicationRecord
  has_many :coaches, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :trips, through: :coaches

  scope :search_garage, (lambda do |city_start, city_end, date|
    joins("LEFT JOIN coaches ON garages.id = coaches.garage_id
      LEFT JOIN trips ON coaches.id = trips.coach_id")
    .where("trips.city_start LIKE ? AND trips.city_finish LIKE ? 
      AND trips.time_start between ? and ?",
      "%#{city_start}%", "%#{city_end}%", 
      "#{date} 00:00:00", date.end_of_day.to_s)
    .group("garages.id")
  end)
end
