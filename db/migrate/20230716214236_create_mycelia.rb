class CreateMycelia < ActiveRecord::Migration[7.0]
  def change
    create_table :mycelia do |t|
      t.string :name
      t.integer :type
      t.string :species
      t.datetime :inoculation_date
      t.references :strain_source, foreign_key: { to_table: :mycelia }
      t.integer :generation
      t.string :external_provider
      t.integer :substrate
      t.integer :container
      t.string :strain_description
      t.integer :shelf_time
      t.string :image_url
      t.float :weight
      t.string :prefix

      t.timestamps
    end
  end
end
