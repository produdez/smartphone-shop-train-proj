class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :location
      t.timestamps
    end
  end
end
