class CreatePrefixCounts < ActiveRecord::Migration[7.0]
  def change
    create_table :prefix_counts do |t|
      t.string :prefix, null: false
      t.integer :count, null: false, default: 0
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end

    add_index :prefix_counts, [:prefix, :organization_id], unique: true
  end
end
