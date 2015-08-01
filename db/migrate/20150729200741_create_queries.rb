class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :uuid, index: true
      t.string :raw
      t.timestamps null: false
    end

    create_table :query_results do |t|
      t.integer :query_id
      t.integer :count
      t.integer :elapsed
      t.integer :stream_id
      t.datetime :created_at, null: false
    end
  end
end
