class MainController < ApplicationController
	require ('myfilter.rb')
	require ('stats.rb')
	require ('select_friends.rb')

	def index
	end

  def login
    render :layout=>false
  end

	def show
		redirect_to ($FB_APP_ROOT)
	end

	def get_friends
		begin
			@fb_friends = @fb_user.friends_with_this_app
		rescue
		# 	redirect_to ($FB_APP_ROOT)
		end
		@fb_all = [@fb_user] + @fb_friends
	end

	def allusers
		fb_user_ids = User.find(:all)
		@fb_users = Array.new
		for fb_id in fb_user_ids
			@fb_users << Facebooker::User::new(fb_id.fb_user_id)
		end

		respond_to do |format|
			format.html
		 	format.xml { render :xml => @details.to_xml }
		end
	end
	

	def newuser
		User.adduser(session[:facebook_session])

    respond_to do |format|
      format.html { redirect_to($FB_APP_ROOT) }
      format.xml  { head :ok }
    end
	end

  def showmyalbumstab
		User.logtime(@user.id)
    MyFilters::reset_session_filters(session)

		@tab = "My Albums"

		respond_to do |format|
			format.html
		 	format.xml { render :xml => @user.to_xml }
		end
  end

=begin
  def iframemyalbumstab

		respond_to do |format|
			format.html
		 	format.xml { render :xml => @details.to_xml }
		end
  end
=end

	def showwantedtab
    MyFilters::reset_session_filters(session)

		respond_to do |format|
			format.fbml
		 	format.xml { render :xml => @user.to_xml }
		end
	end

=begin
  def iframewantedtab

		respond_to do |format|
			format.html
		 	format.xml { render :xml => @details.to_xml }
		end
	end
=end

	def showinvitetab
		@tab = "Invite"
		
		get_friends
		respond_to do |format|
			format.fbml
			format.xml { render :xml => @fb_user.to_xml }
		end
	end

	def showstatstab
		@tab = "Stats"
		@all_stats = Array.new
		get_friends
		for fb_user in @fb_all
			@all_stats << Stats.new("FBUser",fb_user.id)
		end

		@threes = @all_stats.length/3

		respond_to do |format|
			format.fbml
		 	format.xml { render :xml => @all_stats.to_xml }
		end
	end

	def showleaderstab
		@tab = "Leaders"

		get_friends

		all_users = User.find(:all)

		@top_vinyl = Stats.leaders("All_Vinyl")
		@top_heard = Stats.leaders("All_Heard")
		@top_friends = Stats.leaders("Friends_Heard",@fb_all)

		respond_to do |format|
			format.fbml
		 	format.xml { render :xml => @top_vinyl.to_xml }
		end
	end

  def showothersalbumstab
    MyFilters::reset_session_filters(session)
		session[:other_user] = params[:fb_other_in].nil? ? "No User" : params[:fb_other_in]
		@user.save

		respond_to do |format|
			format.fbml
		 	format.xml { render :xml => @user.to_xml }
		end
  end

	def iframeothersalbumstab
		get_friends
		@fb_other_in = session[:other_user]
		@friends = Select_Friends.build_values(@fb_friends, @fb_other_in)
	end

end
