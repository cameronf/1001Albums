namespace :main do
	desc "Replace the given fb_user_id with the index into the user id table"
	task :cleanusers => :environment do

		# default options; will be camelized and converted 
		# to REST request parameters.
	
		fb_user_id=ENV['f']
		user_id=ENV['id']

		@details = Detail.find_all_by_user_id(fb_user_id)
		for detail in @details
			detail.user_id = user_id
			detail.save
		end

	end

end
