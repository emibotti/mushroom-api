class Room < ApplicationRecord
  include MultiTenancyConcern

  has_many :room_inspections
  belongs_to :organization

  validates :name, presence: true
end
