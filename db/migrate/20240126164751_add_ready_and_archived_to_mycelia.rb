class AddReadyAndArchivedToMycelia < ActiveRecord::Migration[7.0]
  def change
    add_column :mycelia, :ready, :boolean, default: false
    add_column :mycelia, :archived, :integer, default: nil
  end
end
