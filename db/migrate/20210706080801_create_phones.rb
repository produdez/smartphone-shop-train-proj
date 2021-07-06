class CreatePhones < ActiveRecord::Migration[6.1]
  def change
    create_table :phones do |t|
      t.integer :manufacture_year , null: false
      t.string :condition , null: false
      t.integer :memory , null: false
      t.float :price , null: false
      t.text :note
      t.string :status , null: false, default: 'in_stock'
      t.timestamps

      t.belongs_to :models, null: false, foreign_key: true
      t.belongs_to :stores, null: false, foreign_key: true
      t.belongs_to :colors, null: false, foreign_key: true
    end
  end
end