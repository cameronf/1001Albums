namespace :main do
	desc "update all of the metadata to new values"
	task :adjustdetails => :environment do

		# default options; will be camelized and converted 
		# to REST request parameters.
	
		@details = Detail.find(:all)
		for detail in @details
			detail.format_id = detail.format_id - 1
			if detail.heard_id == 3
				detail.heard_id = 1
			else
				detail.heard_id = 0
			end
			if detail.owned_id == 2
				detail.owned_id = 0
			end
			if detail.owned_id == 3
				detail.owned_id = 2
			end
			detail.save
		end

	end

end
