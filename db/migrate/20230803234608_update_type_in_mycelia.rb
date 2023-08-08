class UpdateTypeInMycelia < ActiveRecord::Migration[7.0]
  def change
    def up
      Mycelium.where(type: 0).update_all(type: 'Culture')
      Mycelium.where(type: 1).update_all(type: 'Spawn')
      Mycelium.where(type: 2).update_all(type: 'Bulk')
      Mycelium.where(type: 3).update_all(type: 'Fruit')
    end

    def down
      Mycelium.where(type: 'Culture').update_all(type: 0)
      Mycelium.where(type: 'Spawn').update_all(type: 1)
      Mycelium.where(type: 'Bulk').update_all(type: 2)
      Mycelium.where(type: 'Fruit').update_all(type: 3)
    end
  end
end
