class AddDelta < ActiveRecord::Migration
  def self.up
    add_column :albums, :delta, :string
  end

  def self.down
    remove_column :albums, :delta
  end
end
