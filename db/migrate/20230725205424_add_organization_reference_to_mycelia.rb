class AddOrganizationReferenceToMycelia < ActiveRecord::Migration[7.0]
  def change
    add_reference :mycelia, :organization, null: false, foreign_key: true
  end
end
