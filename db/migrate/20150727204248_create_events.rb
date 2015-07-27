class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :stream_id, index: true
      t.jsonb :data
      t.datetime :created_at
    end
  end
end
