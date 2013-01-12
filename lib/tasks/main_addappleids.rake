namespace :main do
	desc "add the apple ids" 
	task :addappleids => :environment do

		# default options; will be camelized and converted 
		# to REST request parameters.
	
		a=IO.readlines(RAILS_ROOT+'/lib/tasks/get_appleid.txt')
		albums = Album.find(:all)

		for album in albums
			album.apple_id = a[album.id-1].chomp
			album.save
		end

	end

end
