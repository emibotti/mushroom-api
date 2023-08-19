class RoomInspectionSerializer < Blueprinter::Base
  fields :humidity, :temperature, :co_2
end