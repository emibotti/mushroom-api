class RoomInspection < ApplicationRecord
  validates :humidity, :temperature, :co_2, presence: true

  belongs_to :room
end
