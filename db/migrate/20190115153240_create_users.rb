class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :pan
      t.integer :security_code
      t.string :expiry_date
      t.string :card_holder_name
      t.float :total_balance
      t.float :reserved_balance

      t.timestamps
    end
  end
end
