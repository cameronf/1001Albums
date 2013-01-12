class AddSort < ActiveRecord::Migration
  def self.up
    add_column :albums, :sortname, :string
  end

  def self.down
		remove_column :albums, :sortname
  end
end
