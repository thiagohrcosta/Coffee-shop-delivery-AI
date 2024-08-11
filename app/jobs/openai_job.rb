require "open-uri"

class OpenaiJob < ApplicationJob
  queue_as :default

  def perform(*args)
    @ticket_id = args[0].id

    reported_problem = {
      title: args[0].title,
      message: args[0].message
    }

    all_messages = TicketAnswer.where(ticket_id: @ticket_id)
    all_messages = all_messages.map(&:message)

    client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"))

    binding.pry
    chaptgpt_response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      messages: [
        { 
          role: "user", 
          content: "You are a helpful and competent customer support agent for CoffeeShop Delivery. 
          Your role is to assist users with their tickets, answer questions clearly and politely, and solve their problems 
          quickly and efficiently. Ensure responses are professional and friendly, providing step-by-step solutions or clear 
          guidance. If you cannot resolve the issue directly, offer alternative solutions or direct users to additional 
          resources. Take note that the user problem is #{reported_problem}. Use the history of interactions #{all_messages} 
          as a base to maintain a real-world conversation. Keep your message within 200 characters. If appropriate, ask if 
          the user would like to open a ticket. Pay attention If user ask to open ticket say this exact answer: 'I’m opening a 
          ticket for you right now. You’ll receive updates soon. If you need anything else, just let me know!'. This should 
          be a exactly answer if user ask to open a ticket because I'll user regex to get this condition."
        }
      ]
    })

    binding.pry
    target_text = "I’m opening a ticket for you right now. You’ll receive updates soon."
    regex_pattern = Regexp.new(Regexp.escape(target_text))


    response = chaptgpt_response["choices"][0]["message"]["content"]

    if response.match(regex_pattern)
      @ticket_answers = TicketAnswer.create(
        message: response,
        user_id: User.where(access: "support_ai").first.id,
        ticket_id: @ticket_id
      )

      support_response = client.chat(parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { 
            role: "user", 
            content: "You are an internal assistant for CoffeeShop Delivery. Based on the user's interaction and 
            conversation history, your task is to understand the issue and create a detailed and accurate summary of 
            what was discussed and the problems encountered. This summary will be used to open an internal support ticket. 
            Limit your summary to 400 characters. Use the previous interactions #{all_messages} and the reported problem 
            #{reported_problem} to formulate your response."
          }
        ]
      })

      support_response = support_response["choices"][0]["message"]["content"]

      title = client.chat(parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { 
            role: "user", 
            content: "You are an internal assistant for CoffeeShop Delivery. Generate a title to be added at a support ticket for this
            report #{support_response}. The title should have max of 100 letters"
          }
        ]
      })

      title = title["choices"][0]["message"]["content"]

      @support_ticket = Ticket.create(
        title: title,
        message: support_response,
        user_id: User.where(access: "support_ai").first.id,
        kind: "open_ai_ticket"
      )

      chaptgpt_response = client.chat(parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { 
            role: "user", 
            content: "You are a helpful and competent customer support agent for CoffeeShop Delivery. 
            Your role is to assist users with their tickets, answer questions clearly and politely, and solve their problems 
            quickly and efficiently. Say to user that a ticket to the support team was oppend with  id #{@support_ticket.id} and
            title #{@support_ticket.title}, you need to inform user about the id #{@support_ticket.id} and
            title #{@support_ticket.title}. Finish saying that the CoffeeShop Delivery will get in touch to fix the reported issue."
          }
        ]
      })
    else
      @ticket_answers = TicketAnswer.create(
        message: response,
        user_id: User.where(access: "support_ai").first.id,
        ticket_id: @ticket_id
      )
    end 
  end
end
