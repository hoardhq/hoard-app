class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :encrypted_password
      t.string :last_signed_in_ip
      t.datetime :last_signed_in_at
      t.timestamps null: false
    end
  end
end
