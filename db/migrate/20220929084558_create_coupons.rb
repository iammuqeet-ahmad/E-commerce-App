# frozen_string_literal: true

class CreateCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :coupons do |t|
      t.string :name, null: false
      t.decimal :discount, null: false, default: 0.0
      t.date :expiry_date, null: false

      t.timestamps
    end
  end
end
