class Stats < ActiveRecord::Base
	attr_reader :fb_user_id, :heard, :owned, :vinyl, :cd, :mp3, :want_own, :want_hear

=begin
	def initialize(id_type, uid)
		case id_type
			when "User"
				user = User.find_by_id(uid)
			when "FBUser"
				user = User.find_by_fb_user_id(uid)
		end
=end
  def initialize(fb_user)
    @fb_user_id = fb_user['id']
    user_id = fb_user['user_id'].to_i
		@heard = Detail.count(:conditions => ["user_id = ? AND heard_id = 1",user_id])
		@owned = Detail.count(:conditions => ["user_id = ? AND owned_id = 2",user_id])
		@vinyl = Detail.count(:conditions => ["user_id = ? AND format_id = 1",user_id])
		@cd = Detail.count(:conditions => ["user_id = ? AND format_id = 2",user_id])
		@mp3 = Detail.count(:conditions => ["user_id = ? AND format_id = 3",user_id])
		@want_own = Detail.count(:conditions => ["user_id = ? AND owned_id = 0",user_id])
		@want_hear = Detail.count(:conditions => ["user_id = ? AND heard_id = 0",user_id])
	end

	def self.leaders(l_type, l_list=nil)
		case l_type
			when "All_Vinyl"
				conditions = ['format_id = 1']
			when "All_Heard"
				conditions = ['heard_id = 1']
			when "Friends_Heard"
				fbuids = Array.new
				for l in l_list
					fbuids << l.id
				end
				conditions = ['heard_id = 1 && users.fb_user_id IN (?)', fbuids]
				include = [:user]
		end				

		top_counts = Detail.count(:conditions => conditions,
															:group => :user_id,
															:include => include,
															:order => "count_all DESC",
															:limit => 10)

		top_list = Array.new
		for top in top_counts
				top_list << self.new("User",top[0])
		end

		return top_list
	end

end
