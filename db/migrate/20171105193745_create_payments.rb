class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.integer :merchant_id
      t.string :merchant_password_hash
      t.string :payment_url
      t.string :email
      t.float :amount
      t.integer :order_id
      t.datetime :order_timestamp
      t.string :error_url

      t.timestamps
    end
  end
end
