class InitialSetup < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :streams do |t|
      t.string :name, limit: 32
      t.string :slug, limit: 32
      t.timestamps null: false
    end

    create_table :events, id: :uuid do |t|
      t.integer :stream_id
      t.jsonb :data
      t.datetime :created_at
    end
    add_index :events, :stream_id

    create_table :queries do |t|
      t.string :uuid
      t.string :raw
      t.timestamps null: false
    end
    add_index :queries, :uuid, unique: true

    create_table :query_results do |t|
      t.integer :query_id
      t.integer :count
      t.integer :elapsed
      t.integer :stream_id
      t.datetime :created_at, null: false
    end

    create_table :users do |t|
      t.string :email
      t.string :encrypted_password
      t.string :last_signed_in_ip
      t.datetime :last_signed_in_at
      t.timestamps null: false
    end

    create_table :api_keys do |t|
      t.string :name
      t.string :key
      t.timestamps null: false
    end
    add_index :api_keys, :key, unique: true
  end
end
