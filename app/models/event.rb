class Event < ApplicationRecord
  include MultiTenancyConcern

  enum event_type: %i[
    inspection
    to_culture
    to_spawn
    to_bulk
    to_fruit
    room_change
    consumed
    contaminated
    sold
    other
    ready
  ].index_with(&:to_s)

  belongs_to :author, class_name: 'User'
  belongs_to :mycelium
  belongs_to :organization

  def self.get_history(mycelium_id)
    query = <<-SQL
      WITH RECURSIVE event_hierarchy AS (
        SELECT e.*
        FROM events e
        WHERE e.mycelium_id = #{mycelium_id}
        UNION
        SELECT e2.*
        FROM events e2
        JOIN mycelia m ON e2.mycelium_id = m.strain_source_id
        JOIN event_hierarchy eh ON m.id = eh.mycelium_id
      )
      SELECT * FROM event_hierarchy
      ORDER BY created_at ASC
    SQL

    result = Event.find_by_sql(query)

    result.to_a
  end
end
