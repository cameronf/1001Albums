class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|

      t.integer :fb_user_id
      t.date :last_visit

      t.timestamps
    end

    execute("alter table users modify fb_user_id bigint")

  end

  def self.down
    drop_table :users
  end
end
