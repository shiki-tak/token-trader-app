class CreateTrades < ActiveRecord::Migration[5.0]
  def change
    create_table :trades do |t|
      t.decimal :price
      t.string :from_token_name
      t.string :to_token_name
      t.decimal :from_token_amount
      t.decimal :to_token_amount
      t.string :maker_address
      t.timestamps
    end
  end
end
