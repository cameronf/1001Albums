class AddAppleId < ActiveRecord::Migration
  def self.up
    add_column :albums, :apple_id, :string
  end

  def self.down
		remove_column :albums, :apple_id
  end
end
