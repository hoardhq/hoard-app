class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.string :name, limit: 32
      t.string :slug, limit: 32
      t.timestamps null: false
    end
  end
end
