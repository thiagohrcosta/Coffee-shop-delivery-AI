class PaymentsController < ApplicationController
  def new
  end

  def create
    token = params[:stripeToken]
    amount = params[:amount].to_i

    charge = Stripe::Charge.create({
      amount: amount,
      currency: 'usd',
      description: 'Coffee purchase',
      source: token,
    })

    if charge.paid
      flash[:notice] = "Payment successful!"
      redirect_to root_path
    else
      flash[:alert] = "Payment failed!"
      render :new
    end
  rescue Stripe::CardError => e
    flash[:alert] = e.message
    render :new
  end

end
