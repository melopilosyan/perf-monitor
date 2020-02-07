class RenameRetryInMinsToRerunInMinsOnTestCritera < ActiveRecord::Migration[5.2]
  def change
    rename_column :test_criteria, :retry_in_mins, :rerun_in_mins
  end
end
