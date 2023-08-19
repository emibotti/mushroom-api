class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :note
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.string :author_name
      t.references :mycelium, null: false, foreign_key: true
      t.string :event_type
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
