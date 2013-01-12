class Album < ActiveRecord::Base
	has_many :details
	has_many :users, :through => :details
end
