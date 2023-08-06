class ChangeMyceliumEnumsToString < ActiveRecord::Migration[7.0]
  def change
    change_column :mycelia, :species, :string
    change_column :mycelia, :substrate, :string
    change_column :mycelia, :container, :string
  end
end
