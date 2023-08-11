class RoomSerializer < Blueprinter::Base
  identifier :id
  field :name
  association :room_current_measure, blueprint: RoomInspectionSerializer

  view :show do
    association :mycelia, blueprint: MyceliumSerializer, view: :card
  end
end