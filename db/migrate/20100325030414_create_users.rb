class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login,    :null => false, :unique => true
      t.string :email,    :null => false, :unique => true
      t.string :password, :null => false
      t.string :security_token
      t.string :security_token_expiry

      t.string   :avatar_file_name
      t.string   :avatar_content_type
      t.integer  :avatar_file_size
      t.datetime :avatar_updated_at
    end
  end

  def self.down
    drop_table :users
  end
end
