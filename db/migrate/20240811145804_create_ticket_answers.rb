class CreateTicketAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :ticket_answers do |t|
      t.string :message, null: false
      t.references :user, null: false, foreign_key: true
      t.references :ticket, null: false, foreign_key: true
      t.timestamps
    end
  end
end
