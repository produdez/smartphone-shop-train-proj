class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores do |t|
      t.string :name ,null: false, index: { unique: true }
      t.string :location
      t.belongs_to :user, index: { unique: true }, null: false, foreign_key: true
      t.timestamps
    end
  end
end
