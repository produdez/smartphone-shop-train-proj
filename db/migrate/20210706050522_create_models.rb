class CreateModels < ActiveRecord::Migration[6.1]
  def change
    create_table :models do |t|
      t.string :name, null: false, index: { unique: true }
      t.text :description
      t.timestamps
      t.belongs_to :operating_system, null: false, foreign_key: true
      t.belongs_to :brand , null: false, foreign_key: true
    end
  end
end
