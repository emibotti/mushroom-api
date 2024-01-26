class AddFlushToMycelia < ActiveRecord::Migration[7.0]
  def change
    add_column :mycelia, :flush, :integer, default: nil
  end
end
