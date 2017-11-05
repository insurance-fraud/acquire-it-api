class PaymentsController < ApplicationController
  # GET /payments
  def attempt_payment
    payment = Payment.new(:merchant_id => payment_params[:merchant_id],
                          :amount => payment_params[:amount],
                          :email => payment_params[:email],
                          :order_id => payment_params[:order_id],
                          :order_timestamp => payment_params[:order_timestamp],
                          :error_url => payment_params[:error_url])
    payment.merchant_password = payment_params[:merchant_password]

    if payment.save
      payment_url = "#{ENV["ACQUIRE_IT_URL"]}/#{payment.id}/pay"

      payment.update_attributes(:payment_url => payment_url)

      render json: { payment_url: payment_url, payment_id: payment.id }
    else
      redirect_to payment_params[:error_url], :message => payment.errors and return
    end
  end

  private
  # Only allow a trusted parameter "white list" through.
  def payment_params
    params.require(:payment).permit(:merchant_id,
                                    :merchant_password,
                                    :payment_url,
                                    :amount,
                                    :email,
                                    :order_id,
                                    :order_timestamp,
                                    :error_url)
  end
end
