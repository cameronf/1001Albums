class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.integer :year
      t.string :title
      t.string :asin
			t.string :alt_buy_string
      t.string :artist

      t.timestamps
    end
  end

  def self.down
    drop_table :albums
  end
end
