class ChangeTypeToStringInMycelia < ActiveRecord::Migration[7.0]
  def change
    change_column :mycelia, :type, :string
  end
end
