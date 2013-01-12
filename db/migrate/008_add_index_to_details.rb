class AddIndexToDetails < ActiveRecord::Migration
  def self.up
    add_index :details, [:album_id, :user_id], :unique => true
    add_index :details, :user_id, :unique => false
  end

  def self.down
    drop_index :details, [:album_id, :user_id]
		drop_index :details, :user_id
  end
end
