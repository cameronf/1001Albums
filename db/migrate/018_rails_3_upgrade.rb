class Rails3Upgrade < ActiveRecord::Migration
  def self.up
    remove_column :users, :state
    add_column :users, :access_token, :text
  end

  def self.down
    remove_column :users, :access_token
    add_column :users, :state, :text
  end
end
