class CreateRoomInspections < ActiveRecord::Migration[7.0]
  def change
    create_table :room_inspections do |t|
      t.references :room, null: false, foreign_key: true
      t.float :humidity
      t.float :temperature
      t.float :co_2
      t.string :notes

      t.timestamps
    end
  end
end
