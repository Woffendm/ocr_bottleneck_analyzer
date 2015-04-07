class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.integer :app_id
      t.integer :data_set_id
      t.integer :thread_count
      t.float :run_time

      t.timestamps null: false
    end
  end
end
