class Select_Friends < ActiveRecord::Base
	attr_accessor :value, :name
	
	def initialize(value,name)
		@value = value
		@name = name	
	end

	def self.build_values(fb_friends,fb_chosen_friend)
		friends = Array.new
		friends << self.new("'No User'","Select Friend")
		for fb_friend in fb_friends
			value = fb_friend.id.to_s
			if fb_friend.id == fb_chosen_friend.to_i
				value += ' selected'
			end
			friends << self.new(value,fb_friend.name)
		end
		return friends
	end

end
