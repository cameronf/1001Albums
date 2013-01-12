class LtrsController < ApplicationController
	before_filter :get_user

	require ('myfilter.rb')
	require ('stats.rb')
	require ('albums_publisher.rb')

	def get_user
		@user = User.init(params[:session_id],session[:facebook_session])	
		begin
			@fb_user = @user.state[:facebook_session].user
			if @user.state[:facebook_session].expired?
				redirect_to ($FB_APP_ROOT)
			end
		rescue
			redirect_to ($FB_APP_ROOT)
		end
	end

	def show
		redirect_to ($FB_APP_ROOT)
	end

  def set_format
    @detail = Detail.find_by_album_id_and_user_id(params[:album_id],@user.id)
    @detail.format_id = params[:format_id]
    @detail.save
		@editable = :true

    respond_to do |format|
      format.html
			format.fbml { render :template => 'ltrs/set_format.html.erb' }
      format.xml{ render:xml => @detail.to_xml }
    end
  end

  def set_owned
    album_id = params[:album_id]
    owned_id = params[:owned_id]
    @detail = Detail.find_by_album_id_and_user_id(album_id,@user.id)
    @detail.owned_id = owned_id
    @detail.save

    respond_to do |format|
      format.html
			format.fbml { render :template => 'ltrs/set_owned.html.erb' }
      format.xml{ render:xml => @detail.to_xml }
    end
  end

  def set_heard
    album_id = params[:album_id]
    heard_id = params[:heard_id]
    @detail = Detail.find_by_album_id_and_user_id(album_id,@user.id)
		already_heard = @detail.heard_id
    @detail.heard_id = heard_id
    @detail.save

# Update profile, mini-feed etc. - with new information based on hearing a new album
# BUGBUG - Facebook changed their profile stuff, so I'm commenting this out for now
=begin
		if already_heard == 0
    	@stats = Stats.new("FBUser", @fb_user.id)
    	AlbumsPublisher.deliver_profile_for_user(@fb_user, @detail, @stats)
    	remainder = @stats.heard % 10
    	if remainder == 0 && @stats.heard != 0
    		begin
    			AlbumsPublisher.deliver_mini_feed(@fb_user, @detail, @stats.heard)
				rescue Facebooker::Session::TooManyUserActionCalls
					logger.error("Too many action calls for the day")
				end
    	end
		end
=end

    respond_to do |format|
			format.html
			format.fbml { render :template => 'ltrs/set_heard.html.erb' }
      format.xml{ render:xml => @detail.to_xml }
    end
  end

  def set_rating
    album_id = params[:album_id]
    rating = params[:rating]
    @detail = Detail.find_by_album_id_and_user_id(album_id,@user.id)
		already_heard = @detail.heard_id
    @detail.rating = rating

# hack in an automatic heard if you rate it

    @detail.heard_id = 1
    @detail.save

=begin
# Update profile, mini-feed etc. - with new information based on hearing a new album, but only if they hadn't heard it already

		if already_heard == 0
    	@stats = Stats.new("FBUser", @fb_user.id)
    	AlbumsPublisher.deliver_profile_for_user(@fb_user, @detail, @stats)
    	remainder = @stats.heard % 10
    	if remainder == 0 && @stats.heard != 0
    		begin
    			AlbumsPublisher.deliver_mini_feed(@fb_user, @detail, @stats.heard)
				rescue Facebooker::Session::TooManyUserActionCalls
					logger.error("Too many action calls for the day")
				end
    	end
		end
=end

    respond_to do |format|
      format.html
			format.fbml { render :template => 'ltrs/set_rating.html.erb' }
      format.xml{ render:xml => @detail.to_xml }
    end
  end

	def clear_details
		album_id = params[:album_id]
		@detail = Detail.cleardetails(@user.id,album_id)

		respond_to do |format|
			format.html
			format.fbml { render :template => 'ltrs/clear_details.html.erb' }
			format.xml{ render:xml => @detail.to_xml }
		end
	end

  def set_note
    album_id = params[:album_id]
    note = params[:note]
    detail = Detail.find_by_album_id_and_user_id(album_id,@user.id)
    detail.notes = note
    detail.save

    render :text => note, :layout => false
  end

  def get_others_albums
		@cur_page = params[:page]
		@user.state[:sort_by] = params[:sort_by] if params[:sort_by]
		@user.state[:filter_by] = params[:filter_by] if params[:filter_by]
		@user.state[:filter_details_1] = params[:filter_details_1] if params[:filter_details_1]
		@user.state[:filter_details_2] = params[:filter_details_2] if params[:filter_details_2]
		@user.state[:other_user] = params[:fb_other_in] if params[:fb_other_in]
		@user.save

		if @user.state[:other_user] != "No User"
			other_user_id = User.find_by_fb_user_id(@user.state[:other_user])
    	@details = Detail.getfiltereddetails(other_user_id,@user,@cur_page)
			begin
				@fb_user = Facebooker::User::new(@user.state[:other_user])
				@fb_name = @fb_user.name + "'s"
			rescue
				@fb_name = "Other's"
			end

			respond_to do |format|
				format.html
				format.fbml { render :template => 'ltrs/get_others_albums.html.erb' }
			 	format.xml { render :xml => @details.to_xml }
			end
		else
			respond_to do |format|
				format.html { render :template => 'ltrs/no_others_albums.html.erb' }
				format.fbml { render :template => 'ltrs/no_others_albums.html.erb' }
			 	format.xml { render :text => "No Friend Chosen" }
			end

		end
  end
	
  def get_my_albums
		@cur_page = params[:page]
		@user.state[:sort_by] = params[:sort_by] if params[:sort_by]
		@user.state[:filter_by] = params[:filter_by] if params[:filter_by]
		@user.state[:filter_details_1] = params[:filter_details_1] if params[:filter_details_1]
		@user.state[:filter_details_2] = params[:filter_details_2] if params[:filter_details_2]
		@user.save

    @details = Detail.getfiltereddetails(@user.id,@user,@cur_page)

		respond_to do |format|
			format.html
			format.fbml { render :template => 'ltrs/get_my_albums.html.erb' }
		 	format.xml { render :xml => @details.to_xml }
		end
  end
	
  def populate_filters
		@user.state[:filter_by] = params[:filter_by]
		@user.save
		@filter_by = @user.state[:filter_by]
    @myfilters = MyFilter.getfilters(@filter_by)

		respond_to do |format|
			format.html
			format.fbml { render :template => 'ltrs/populate_filters.html.erb' }
		 	format.xml { render :xml => @myfilters.to_xml }
		end
  end

	def get_wanted_albums
		@cur_page = params[:page]
		@user.state[:sort_by] = params[:sort_by] if params[:sort_by]
		@user.state[:wanted_type] = params[:wanted_type] if params[:wanted_type]
		@user.state[:filter_by] = params[:filter_by] if params[:filter_by]
		@user.state[:filter_details_1] = params[:filter_details_1] if params[:filter_details_1]
		@user.state[:filter_details_2] = params[:filter_details_2] if params[:filter_details_2]
		@user.save

    @details = Detail.getwanteddetails({:user => @user,:page => @cur_page})

		respond_to do |format|
			format.html
			format.fbml { render :template => 'ltrs/get_wanted_albums.html.erb' }
		 	format.xml { render :xml => @details.to_xml }
		end
	end

	def printable_list

    @details = Detail.getwanteddetails({:user => @user, :printable => true})

		respond_to do |format|
			format.html
			format.fbml { render :template => 'ltrs/printable_list.html.erb' }
		 	format.xml { render :xml => @details.to_xml }
		end
	end

	def mobile_list

    @details = Detail.getwanteddetails({:user => @user, :printable => true})

		respond_to do |format|
			format.html
		 	format.xml { render :xml => @details.to_xml }
		end
	end
end
