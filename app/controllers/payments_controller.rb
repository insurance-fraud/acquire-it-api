class PaymentsController < ApplicationController
  # POST /attempt_payment
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

      render json: { payment_url: payment_url, payment_id: payment.id }, status: :ok
    else
      render json: { error_url: payment_params[:error_url], error: payment.errors }, status: :not_found
    end
  end

  private
  # Only allow a trusted parameter "white list" through.
  def payment_params
    logger.info params
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
