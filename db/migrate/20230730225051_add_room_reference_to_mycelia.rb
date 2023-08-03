class AddRoomReferenceToMycelia < ActiveRecord::Migration[7.0]
  def change
    add_reference :mycelia, :room, foreign_key: true
  end
end
