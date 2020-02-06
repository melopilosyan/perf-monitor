class AddErrorToTestResult < ActiveRecord::Migration[5.2]
  def change
    add_column :test_results, :error, :string
  end
end
