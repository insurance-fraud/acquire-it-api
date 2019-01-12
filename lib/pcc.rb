module PCC
  def self.pay(card_data, acquirer_order_id, acquirer_order_timestamp)
    body = card_data.merge(
      :acquirer_order_id => acquirer_order_id,
      :acquirer_order_timestamp => acquirer_order_timestamp
    )

    HTTParty.post(
      "http://localhost:5000/pay",
      body: body,
      timeout: 2
    )
  end
end
