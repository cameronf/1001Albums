class FixFormats < ActiveRecord::Migration
  def self.up
		drop_table :formats
    create_table :formats do |t|
      t.string :name

      t.timestamps
    end

    Format.create :name => "Vinyl"
    Format.create :name => "CD"
    Format.create :name => "mp3"
  end

  def self.down
    drop_table :formats
    create_table :formats do |t|
      t.string :name

      t.timestamps
    end

    Format.create :name => "None"
    Format.create :name => "Vinyl"
    Format.create :name => "CD"
    Format.create :name => "Online"
  end
end
