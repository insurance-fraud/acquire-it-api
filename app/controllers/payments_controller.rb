class PaymentsController < ApplicationController
  # POST /attempt_payment
  def attempt_payment
    logger.info "Started attemp_payment"

    payment = Payment.new(:merchant_id => payment_params[:merchant_id],
                          :amount => payment_params[:amount],
                          :merchant_order_id => payment_params[:order_id],
                          :merchant_order_timestamp => payment_params[:order_timestamp],
                          :success_url => payment_params[:success_url],
                          :error_url => payment_params[:error_url],
                          :failed_url => payment_params[:failed_url])
    payment.merchant_password = payment_params[:merchant_password]

    if payment.save
      payment_url = "http://localhost:4000/pay"

      payment.update_attributes(:payment_url => payment_url)

      render json: { payment_url: payment_url, payment_id: payment.id }, status: :ok
    else
      render json: { error_url: payment_params[:error_url], error: payment.errors },
        status: :not_found
    end
  end

  def pay
    payment = Payment.find(params[:id])
    pan = params[:pan]
    security_code = params[:security_code]
    card_holder_name = params[:card_holder_name]
    expiry_date = params[:expiry_date]

    user = User.find_by(pan: pan,
                        security_code: security_code,
                        card_holder_name: card_holder_name,
                        expiry_date: expiry_date)

    response_body = { merchant_order_id: payment.merchant_order_id,
                      acquirer_order_id: payment.acquirer_order_id,
                      acquirer_order_timestamp: payment.acquirer_order_timestamp,
                      payment_id: payment.id,
                      success_url: payment.success_url,
                      error_url: payment.error_url,
                      failed_url: payment.failed_url }

    amount = payment.amount

    if user.present?
      if user.total_balance - user.reserved_balance >= amount
        user.update(reserved_balance: user.reserved_balance + amount)

        render json: response_body.merge(success: true), status: :ok
      else
        render json: response_body.merge(success: false), status: :error
      end
    else
      payment.update(acquirer_order_id: SecureRandom.hex(10),
                     acquirer_order_timestamp: DateTime.now)

      resp = PCC.pay({ pan: pan,
                       security_code: security_code,
                       card_holder_name: card_holder_name,
                       expiry_date: expiry_date },
                       payment.acquirer_order_id,
                       payment.acquirer_order_timestamp,
                       amount)

      response_body = { merchant_order_id: payment.merchant_order_id,
                        acquirer_order_id: payment.acquirer_order_id,
                        acquirer_order_timestamp: payment.acquirer_order_timestamp,
                        payment_id: payment.id,
                        success_url: payment.success_url,
                        error_url: payment.error_url,
                        failed_url: payment.failed_url }

      if resp.code == 200
        render json: response_body.merge(success: true), status: :ok
      else
        render json: response_body.merge(success: false), status: :error
      end
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
                                    :success_url,
                                    :failed_url,
                                    :error_url)
  end
end
