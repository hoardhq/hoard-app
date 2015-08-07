class CreateImporters < ActiveRecord::Migration
  def change
    create_table :importers do |t|
      t.integer :stream_id
      t.boolean :active, default: true
      t.string :provider
      t.string :endpoint
      t.integer :schedule
    end
  end
end
