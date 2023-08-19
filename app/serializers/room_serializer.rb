class RoomSerializer < Blueprinter::Base
  identifier :id
  field :name

  view :show do
    association :room_current_measure, blueprint: RoomInspectionSerializer
    association :mycelia, blueprint: MyceliumSerializer, view: :card
  end
end