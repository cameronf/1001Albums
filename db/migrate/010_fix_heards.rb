class FixHeards < ActiveRecord::Migration
  def self.up
		drop_table :heards
    create_table :heards do |t|
      t.string :state

      t.timestamps
    end
    Heard.create :state => "Heard It"
  end

  def self.down
    drop_table :heards
    create_table :heards do |t|
      t.string :state

      t.timestamps
    end
    Heard.create :state => "Don't Care"
    Heard.create :state => "Want To Hear It"
    Heard.create :state => "Heard It"
  end
end
