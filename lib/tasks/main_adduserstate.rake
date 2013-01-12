namespace :main do
	desc "add a state hash to existing users"
	task :adduserstate => :environment do

		# default options; will be camelized and converted 
		# to REST request parameters.
	
		@users = User.find(:all)
		for user in @users
			user.state=Hash.new
			user.save
		end

	end

end
