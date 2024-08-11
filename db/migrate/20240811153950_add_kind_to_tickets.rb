class AddKindToTickets < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :kind, :integer, default: 0
  end
end
