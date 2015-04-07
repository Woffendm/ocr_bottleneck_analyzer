class CreateDataSets < ActiveRecord::Migration
  def change
    create_table :data_sets do |t|
      t.string :name
      t.integer :size

      t.timestamps null: false
    end
  end
end
