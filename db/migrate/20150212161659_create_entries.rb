class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :run_id
      t.integer :function_id
      t.float :run_time
      t.float :run_time_no_calls
      t.integer :calls

      t.timestamps null: false
    end
  end
end
