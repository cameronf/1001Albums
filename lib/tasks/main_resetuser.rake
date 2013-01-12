namespace :main do
	desc "Reset all of the metadata for a given user"
	task :resetuser => :environment do

		# default options; will be camelized and converted 
		# to REST request parameters.
	
		user_id=ENV['id']

		@details = Detail.find_all_by_user_id(user_id)
		for detail in @details
			detail.heard_id = 0
			detail.owned_id = 0
			detail.format_id = 0
			detail.rating = 0
			detail.notes = nil
			detail.save
		end

	end

end
