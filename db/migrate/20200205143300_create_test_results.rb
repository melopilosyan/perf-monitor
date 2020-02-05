class CreateTestResults < ActiveRecord::Migration[5.2]
  def change
    create_table :test_results do |t|
      t.references :test_criterium, foreign_key: true
      t.integer :ttfb
      t.integer :tti
      t.integer :speed_index
      t.boolean :passed

      t.timestamps
    end
  end
end
