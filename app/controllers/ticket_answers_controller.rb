class TicketAnswersController < ApplicationController
  before_action :set_ticket

  def create
    @ticket_answer = @ticket.ticket_answers.build(ticket_answer_params)
    @ticket_answer.user_id = current_user.id

    if @ticket_answer.save
      redirect_to ticket_path(@ticket), notice: 'Your response has been submitted.'
      OpenaiJob.perform_now(@ticket)
    else
      redirect_to ticket_path(@ticket), alert: 'There was an error submitting your response.'
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  # Strong parameters for ticket_answer
  def ticket_answer_params
    params.require(:ticket_answer).permit(:message)
  end
end
