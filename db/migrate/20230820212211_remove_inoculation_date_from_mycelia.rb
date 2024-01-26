class RemoveInoculationDateFromMycelia < ActiveRecord::Migration[7.0]
  def change
    remove_column :mycelia, :inoculation_date
  end
end
