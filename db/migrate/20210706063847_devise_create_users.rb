# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''
      ## Rememberable
      t.datetime :remember_created_at, comment: 'Account creation time, different from timestamp where it stores update time'
      t.timestamps null: false
      t.string :name, null: false
      t.string :phone
      t.string :role, null: false, default: 'user' # admin or user!
    end

    add_index :users, :email, unique: true
  end
end
