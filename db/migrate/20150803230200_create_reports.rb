class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :stream_id
      t.string :name, limit: 50
      t.string :filter
      t.string :group
      t.string :function
      t.string :schedules, array: true, default: []
      t.timestamps null: false
    end
    create_table :report_results do |t|
      t.integer :report_id
      t.string :status, default: 'queued'
      t.jsonb :results
      t.integer :elapsed
      t.integer :count
      t.timestamps null: false
    end
  end
end
