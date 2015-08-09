class DropReports < ActiveRecord::Migration
  def change
    drop_table :reports
    drop_table :report_results
    drop_table :queries
    drop_table :query_results
  end
end
