class CreatePosessions < ActiveRecord::Migration[5.0]
  def change
    create_table :posessions do |t|
      t.integer :user_id
      t.integer :token_id
      t.decimal :balance
      t.timestamps
    end
  end
end
