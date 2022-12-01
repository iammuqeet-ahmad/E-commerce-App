# frozen_string_literal: true

# This is migration for Product
class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :serialNo, unique: true
      t.string :name, null: false
      t.text :description, null: false
      t.integer :quantity, null: false, default: 1
      t.integer :price,   null: false

      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
