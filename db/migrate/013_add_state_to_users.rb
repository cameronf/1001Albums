class AddStateToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :state, :text
  end

  def self.down
		remove_column :users, :state
  end
end
