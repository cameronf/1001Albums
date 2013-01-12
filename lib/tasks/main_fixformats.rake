namespace :main do
	desc "Change all the default formats to 1 (Null)"
	task :fixformats => :environment do

		# default options; will be camelized and converted 
		# to REST request parameters.
	
		@details = Detail.find_all_by_user_id(27)
		for detail in @details
			detail.format_id = 1 
			detail.save
		end

	end

end
