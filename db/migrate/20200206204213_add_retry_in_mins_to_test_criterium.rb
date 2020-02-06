class AddRetryInMinsToTestCriterium < ActiveRecord::Migration[5.2]
  def change
    add_column :test_criteria, :retry_in_mins, :integer, default: 0
  end
end
