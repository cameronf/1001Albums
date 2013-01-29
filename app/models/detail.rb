class Detail < ActiveRecord::Base
	belongs_to :format
	belongs_to :album
	belongs_to :heard
	belongs_to :owned
	belongs_to :user

  SORT_KEY = ['album_id ASC', 'albums.sortname ASC, album_id ASC', 'rating DESC, album_id ASC']

	def self.getdetails(user_id, page)
		paginate :per_page => 77, :page => page,
						 :conditions => ["user_id = ?", user_id],
						 :order => 'album_id ASC',
						 :include => :album
	end

	def self.cleardetails(user_id,album_id)
		d = self.find_by_user_id_and_album_id(user_id, album_id)
		d.notes = nil
		d.format_id = 0
		d.heard_id = 0
		d.owned_id = 0
		d.rating = 0
		d.save

		return d
	end

	def self.getwanteddetails(user_id, session, page, downloadable = nil)

		sort_by = session[:wanted_sort_by].to_i
		wanted_type = session[:wanted_type]
		filter_by = session[:wanted_filter_by].to_i
		filter_details_1 = session[:wanted_filter_details_1]
		filter_details_2 = session[:wanted_filter_details_2]

		if wanted_type == "heard"
			conditions = ["user_id = ? and details.heard_id = 0", user_id]
		else
			conditions = ["user_id = ? and details.owned_id = 0", user_id]
		end

		case filter_by
			# Filter by YEAR
			when 1
				lower_year = filter_details_1.to_i
				upper_year = filter_details_2.to_i
				if (lower_year > upper_year)
					lower_year,upper_year = upper_year,lower_year
				end

				conditions[0] = conditions[0] + " and albums.year >= ? and albums.year <= ?"
				conditions << lower_year
				conditions << upper_year

			# Filter by Artist
			when 2
				if filter_details_1 == 'NUM'
					conditions[0] = conditions[0] + " and albums.sortname NOT REGEXP '^[[:alpha:]]'"
				else	
					conditions[0] = conditions[0] + " and albums.sortname LIKE ?"
					conditions << filter_details_1 + '%'
				end
		end
		
		if downloadable
			self.find	:all,
					 			:conditions => conditions,
					 			:order => SORT_KEY[sort_by],
						  	:include => :album
		else
			paginate  :per_page => 150, :page => page,
					 			:conditions => conditions,
					 			:order => SORT_KEY[sort_by],
						  	:include => :album
		end

	end

	def self.getmydetails(user_id, session, page)
		sort_by = session[:my_sort_by].to_i
		filter_by = session[:my_filter_by].to_i
		filter_details_1 = session[:my_filter_details_1]
		filter_details_2 = session[:my_filter_details_2]

		if filter_by == 0 || filter_details_1.to_i == -1
			conditions = ["user_id = ?", user_id]
		else
			case filter_by
				# Filter by YEAR
				when 1
					lower_year = filter_details_1.to_i
					upper_year = filter_details_2.to_i

					if (lower_year > upper_year)
						lower_year,upper_year = upper_year,lower_year
					end

					conditions = ["user_id = ? and albums.year >= ? and albums.year <= ?",user_id,lower_year,upper_year]
				# Filter by Artist
				when 2
					if filter_details_1 == 'NUM'
						conditions = ["user_id = ? and albums.sortname NOT REGEXP '^[[:alpha:]]'",user_id]
					else	
						conditions = ["user_id = ? and albums.sortname LIKE ?",user_id,filter_details_1+'%']
					end
				# Filter by Rating
				when 3
					if filter_details_1 == '0'
						conditions = ["user_id = ? and rating = ?",user_id,filter_details_1.to_i]
					else
						conditions = ["user_id = ? and rating >= ?",user_id,filter_details_1.to_i]
					end
				# Filter by Format
				when 4
					conditions = ["user_id = ? and format_id = ?",user_id, filter_details_1.to_i]
				# Filter by Owned
				when 5
					if filter_details_1 == '3'
						conditions = ["user_id = ? and owned_id = 2 and heard_id = 0",user_id]
					else
						conditions = ["user_id = ? and owned_id = ?",user_id, filter_details_1.to_i]
					end
				# Filter by Heard
				when 6
					conditions = ["user_id = ? and heard_id = ?",user_id, filter_details_1.to_i]
			end
		end

		paginate  :per_page => 77, :page => page,
					 		:conditions => conditions,
					 		:order => SORT_KEY[sort_by],
						  :include => :album
				
	end

end
