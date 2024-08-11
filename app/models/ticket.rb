class Ticket < ApplicationRecord
  has_many :ticket_answers

  enum kind: {
    user_ticket: 0,
    open_ai_ticket: 1,
  }
end
