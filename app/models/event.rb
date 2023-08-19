class Event < ApplicationRecord
  include MultiTenancyConcern

  enum event_type: %i[
    inspection
    to_spawn
    to_bulk
    to_fruit
    room_change
  ].index_with(&:to_s)

  belongs_to :author, class_name: 'User'
  belongs_to :mycelium
  belongs_to :organization
end
