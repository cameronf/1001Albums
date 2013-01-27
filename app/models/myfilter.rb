class MyFilter
	attr_accessor :index
	attr_accessor :text

  def self.reset_session_filters(session)
    session[:sort_by] = 0
    session[:filter_by] = 0
    session[:filter_details_1] = -1
    session[:filter_details_2] = 0
    session[:other_user] = "No User"
    session[:wanted_type] = "owned"
  end

	def self.getfilters(filter_key)
		filters = self.new
		filters.index = -1
		filters.text = "Show All"
		filters = [filters]
		case filter_key.to_i
		# 1= Year - which is special cased - easier to just build it in the html directly
		# Filter Album
		when 2
			for alpha_str in ('A'..'Z')
				temp = self.new
				temp.index = alpha_str
				temp.text = 'Starts with '+alpha_str
				filters = filters + [temp]
			end
			temp=self.new
			temp.index = 'NUM'
			temp.text = 'Starts with #'
			filters = filters + [temp]
		# Filter Rating
		when 3
			temp = self.new
			temp.index = 0
			temp.text = "Unrated"
			filters = filters + [temp]
			temp = self.new
			temp.index = 1
			temp.text = "1 or More"
			filters = filters + [temp]
			temp = self.new
			temp.index = 2
			temp.text = "2 or More"
			filters = filters + [temp]
			temp = self.new
			temp.index = 3
			temp.text = "3 or More"
			filters = filters + [temp]
			temp = self.new
			temp.index = 4
			temp.text = "4 or More"
			filters = filters + [temp]
		# Filter Format
		when 4
			formats = Format.find(:all)
			temp = self.new
			temp.index = 0
			temp.text = "No Format"
			filters = filters + [temp]
			for format in formats
				temp = self.new
				temp.index = format.id
				temp.text = format.name
				filters = filters + [temp]
			end
		# Filter Owned
		when 5
			owneds = Owned.find(:all)
			temp = self.new
			temp.index = 0
			temp.text = "Wanted"
			filters = filters + [temp]
			for owned in owneds
				temp = self.new
				temp.index = owned.id
				temp.text = owned.state
				filters = filters + [temp]
			end
			# Hack in an extra - owned but not heard
			temp = self.new
			temp.index = 3
			temp.text = "Owned Not Heard"
			filters = filters + [temp]
		# Filter Heard
		when 6
			heards = Heard.find(:all)
			temp = self.new
			temp.index = 0
			temp.text = "Unheard"
			filters = filters + [temp]
			for heard in heards
				temp = self.new
				temp.index = heard.id
				temp.text = heard.state
				filters = filters + [temp]
			end
		end

		return filters
	end
			
end
