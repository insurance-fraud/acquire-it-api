module PCC
  def self.pay(card_data, acquirer_order_id, acquirer_order_timestamp, amount)
    body = card_data.merge(
      :acquirer_order_id => acquirer_order_id,
      :acquirer_order_timestamp => acquirer_order_timestamp,
      :amount => amount
    )

    HTTParty.post(
      "http://localhost:5000/payments/pay",
      body: body,
      timeout: 5
    )
  end
end
