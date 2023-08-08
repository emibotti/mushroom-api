class Room < ApplicationRecord
  include MultiTenancyConcern

  has_many :room_inspections
  has_many :mycelia
  belongs_to :organization

  validates :name, presence: true
end
