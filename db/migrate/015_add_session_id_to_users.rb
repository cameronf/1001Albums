class AddSessionIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :session_id, :string
    add_index :users, :session_id, :unique => true
    add_index :users, :fb_user_id, :unique => true
  end

  def self.down
		remove_column :users, :session_id
		drop_index :details, :fb_user_id
		drop_index :details, :session_id
  end
end
