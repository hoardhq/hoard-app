class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :name
      t.string :key, index: true, unique: true
      t.timestamps null: false
    end
  end
end
