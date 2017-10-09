class CreateIssues < ActiveRecord::Migration[5.0]
  def change
    create_table :issues do |t|

      t.timestamps
    end
  end
end
