class Admin::TicketsController < ApplicationController
  def index
    @tickets = Ticket.where(kind: "open_ai_ticket")
  end
end
