class Room < ApplicationRecord
  include MultiTenancyConcern

  has_many :room_inspections
  has_many :mycelia
  belongs_to :organization

  validates :name, presence: true

  def room_current_measure
    self.room_inspections.last
  end
end
