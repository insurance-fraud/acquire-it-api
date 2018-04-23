require 'rails_helper'

RSpec.describe "Payments", type: :request do
  describe "POST /attempt_payment" do
    it "works! (now write some real specs)" do
      post attempt_payment_payments_path, params: { payment: {
        merchant_id: 1,
        merchant_password: "strongpassword",
        amount: 10000.00,
        email: "test@example.com",
        order_id: 12,
        order_timestamp: Time.now,
        error_url: "acquire-it.herokuapp.com/error" }
      }

      expect(response).to have_http_status(200)
    end
  end
end
