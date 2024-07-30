class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :cart, null: false, foreign_key: true
      t.float :total_price, null: false
      t.string :status, null: false, default: "pending"
      t.datetime :paid_at
      t.timestamps
    end
  end
end
