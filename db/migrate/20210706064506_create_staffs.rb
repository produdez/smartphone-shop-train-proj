class CreateStaffs < ActiveRecord::Migration[6.1]
  def change
    create_table :staffs do |t|
      t.timestamps
      t.string :role, default: 'staff' # staff or manager
      t.belongs_to :user, index: { unique: true }, null: false, foreign_key: true
      t.belongs_to :store, null: false, foreign_key: true
    end
  end
end
