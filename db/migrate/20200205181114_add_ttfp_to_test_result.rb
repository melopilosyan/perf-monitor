class AddTtfpToTestResult < ActiveRecord::Migration[5.2]
  def change
    add_column :test_results, :ttfp, :integer
  end
end
