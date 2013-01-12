namespace :main do
	desc "delete a user from the application"
	task :cleanusers => :environment do

		# default options; will be camelized and converted 
		# to REST request parameters.
	
		user_id=ENV['id']

		@details = Detail.find_all_by_user_id(user_id)
		for detail in @details
			detail.delete
		end

		user = User.find_by_user_id(user_id)
		user.delete

	end

end
