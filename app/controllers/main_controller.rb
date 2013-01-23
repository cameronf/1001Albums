class MainController < ApplicationController
	require ('myfilter.rb')
	require ('stats.rb')
	require ('select_friends.rb')

	def index
	end

  def login
  end

	def new_entry
		@user = User.find(23)
		@user.update_attribute(:session_id,request.session_options[:id])
		redirect_to (iframemyalbumstab_url)
	end

	def show
		redirect_to ($FB_APP_ROOT)
	end

=begin
	def get_user
		@user = User.init(request.session_options[:id],session[:facebook_session])
		# begin
			# @fb_user = @user.state[:facebook_session].user
		# rescue
			# redirect_to ($FB_APP_ROOT)
		# end
	end	
=end

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
		@user.state[:sort_by] = 0
		@user.state[:filter_by] = 0
		@user.state[:filter_details_1] = -1
		@user.state[:filter_details_2] = 0
		@user.state[:other_user] = "No User"
		@user.save

		@tab = "My Albums"

		respond_to do |format|
			format.html
		 	format.xml { render :xml => @user.to_xml }
		end
  end

  def iframemyalbumstab
    # @details = Detail.getdetails(@user.id,params[:page])

		respond_to do |format|
			format.html
		 	format.xml { render :xml => @details.to_xml }
		end
  end

	def showwantedtab
		@tab = "Wanted"
		@user.state[:sort_by] = 0
		@user.state[:wanted_type] = "owned"
		@user.state[:filter_by] = 0
		@user.state[:filter_details_1] = -1 
		@user.state[:filter_details_2] = 0
		@user.save

		respond_to do |format|
			format.fbml
		 	format.xml { render :xml => @user.to_xml }
		end
	end

  def iframewantedtab

    # @details = Detail.getwanteddetails({:user => @user,:page => params[:page]})

		respond_to do |format|
			format.html
		 	format.xml { render :xml => @details.to_xml }
		end
	end

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
		@tab = "Others Albums"
		@user.state[:sort_by] = 0
		@user.state[:filter_by] = 0
		@user.state[:filter_details_1] = -1
		@user.state[:filter_details_2] = 0
		@user.state[:other_user] = params[:fb_other_in].nil? ? "No User" : params[:fb_other_in]
		@user.save

		respond_to do |format|
			format.fbml
		 	format.xml { render :xml => @user.to_xml }
		end
  end

	def iframeothersalbumstab
		get_friends
		@fb_other_in = @user.state[:other_user]
		@friends = Select_Friends.build_values(@fb_friends, @fb_other_in)
	end

end
