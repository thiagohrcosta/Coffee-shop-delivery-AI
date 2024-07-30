class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.float :amount, null: false
      t.string :status, null: false
      t.string :transaction_id
      t.datetime :paid_at
      t.timestamps
    end
  end
end
