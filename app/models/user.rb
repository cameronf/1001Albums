class User < ActiveRecord::Base
  attr_accessible :session_id, :access_token
	has_many :details
	has_many :albums, :through => :details
	has_many :heards, :through => :details
	has_many :owneds, :through => :details
	has_many :formats, :through => :details 	

	serialize :state, Hash

	# Logs the last time a user was seen

	def self.logtime(user_id)

		user = self.find_by_id(user_id)
		t=Time.new
		user.last_visit = t.to_date
		user.save

	end	

	# Creates a new user, and populates an empty list for them
	
	def self.adduser(facebook_session)

		user = self.new
		user.fb_user_id = facebook_session.user.id 
		user.state = Hash.new
		user.state[:facebook_session] = facebook_session
		user.session_id = facebook_session.session_key
		user.save
		self.logtime(user.id)
		
		albums = Album.find(:all)
		for album in albums
			
			detail = Detail.new
			detail.user_id = user.id
			detail.album_id = album.id
			detail.save

		end
	end

	# Initializes the user, session, and state variables - deals with the situation where there are no cookies
	# session_id is passed as a param from any iframe call, if facebook_session is the only thing there, then I'm
	# in one of the tab calls. 
	
	def self.init(session_id, facebook_session)
		if facebook_session.nil?
			user = self.find_by_session_id(session_id)
		elsif facebook_session.secured?
			user = self.find_by_fb_user_id(facebook_session.user.id)

			if user.state.nil? || user.state[:facebook_session].nil?
				user.state = Hash.new
				user.state[:facebook_session] = facebook_session
				user.save
			end

			if user.session_id != facebook_session.session_key
				user.session_id = facebook_session.session_key
				user.save
			end

			if user.state[:facebook_session].session_key != facebook_session.session_key ||
				 user.state[:facebook_session].expired?
				user.state[:facebook_session] = facebook_session

				user.save
			end
		else
			user = self.find_by_session_id(session_id)
		end

		return user
	end

	# Deletes a user, and all of their history
	
	def self.deleteuser(fb_user_id)

		user = self.find_by_fb_user_id(fb_user_id)
		@details = user.details
		for detail in @details
			detail.destroy
		end
		user.destroy

	end
end
