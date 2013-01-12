class CreateFormats < ActiveRecord::Migration
  def self.up
    create_table :formats do |t|
      t.string :name

      t.timestamps
    end

    Format.create :name => "None"
    Format.create :name => "Vinyl"
    Format.create :name => "CD"
    Format.create :name => "Online"
  end

  def self.down
    drop_table :formats
  end
end
