class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      t.timestamps
      t.belongs_to :users, null: false, foreign_key: true
      t.belongs_to :stores, null: false, foreign_key: true
    end
  end
end
