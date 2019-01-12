class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.integer :merchant_id
      t.string :merchant_password_hash
      t.string :payment_url
      t.float :amount
      t.integer :merchant_order_id
      t.datetime :merchant_order_timestamp
      t.integer :acquirer_order_id
      t.datetime :acquirer_order_timestamp
      t.string :success_url
      t.string :error_url
      t.string :failed_url

      t.timestamps
    end
  end
end
