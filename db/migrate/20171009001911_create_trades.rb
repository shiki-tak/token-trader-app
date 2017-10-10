class CreateTrades < ActiveRecord::Migration[5.0]
  def change
    create_table :trades do |t|
      t.decimal :price
      t.decimal :from_token
      t.decimal :to_token
      t.string :maker_address
      t.timestamps
    end
  end
end
