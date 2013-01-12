class CreateOwneds < ActiveRecord::Migration
  def self.up
    create_table :owneds do |t|
      t.string :state
      t.timestamps
    end
    Owned.create :state => "Don't Care"
    Owned.create :state => "Want It"
    Owned.create :state => "Own It"
  end

  def self.down
    drop_table :owneds
  end
end
