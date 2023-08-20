class EventSerializer < Blueprinter::Base
  identifier :id
  field :note
  field :author_name
  field :mycelium_id
  field :event_type
  field :created_at
end
