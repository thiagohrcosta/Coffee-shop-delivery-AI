class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :title
      t.float :price
      t.string :description
      t.timestamps
    end
  end
end
