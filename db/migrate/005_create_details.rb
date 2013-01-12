class CreateDetails < ActiveRecord::Migration
  def self.up
    create_table :details do |t|
      t.references :user
			t.references :album
			t.references :format, :default => 0 # Default to no format
			t.references :heard, :default => 0 # Default to want to hear to it
			t.references :owned, :default => 0 # Default to want to own it
      t.integer :rating, :default => 0 # Default to no opinion
			t.string :notes

      t.timestamps
    end

  end

  def self.down
    drop_table :details
  end
end
