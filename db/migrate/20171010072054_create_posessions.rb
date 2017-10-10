class CreatePosessions < ActiveRecord::Migration[5.0]
  def change
    create_table :posessions do |t|
      t.string :user_id
      t.string :token_id
      t.decimal :balance
      t.timestamps
    end
  end
end
