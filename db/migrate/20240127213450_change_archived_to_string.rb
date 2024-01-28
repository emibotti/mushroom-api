class ChangeArchivedToString < ActiveRecord::Migration[7.0]
  def change
    change_column :mycelia, :archived, :string
  end
end
