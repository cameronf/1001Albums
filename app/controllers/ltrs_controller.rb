class LtrsController < ApplicationController
	require ('myfilter.rb')
	require ('stats.rb')
  require ('fbutils.rb')
	# require ('albums_publisher.rb')

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
		session[:sort_by] = params[:sort_by] if params[:sort_by]
		session[:filter_by] = params[:filter_by] if params[:filter_by]
		session[:filter_details_1] = params[:filter_details_1] if params[:filter_details_1]
		session[:filter_details_2] = params[:filter_details_2] if params[:filter_details_2]
		session[:other_user] = params[:fb_other_in] if params[:fb_other_in]
		@user.save

		if session[:other_user] != "No User"
			other_user_id = User.find_by_fb_user_id(session[:other_user])
    	@details = Detail.getfiltereddetails(other_user_id,session,@cur_page)
			begin
				@fb_user = Facebooker::User::new(session[:other_user])
				@fb_name = @fb_user.name + "'s"
			rescue
				@fb_name = "Other's"
			end

			respond_to do |format|
				format.html
			 	format.xml { render :xml => @details.to_xml }
			end
		else
			respond_to do |format|
				format.html { render :template => 'ltrs/no_others_albums.html.erb' }
			 	format.xml { render :text => "No Friend Chosen" }
			end

		end
  end
	
  def get_my_albums
		@cur_page = params[:page]
		session[:my_sort_by] = params[:sort_by] if params[:sort_by]
		session[:my_filter_by] = params[:filter_by] if params[:filter_by]
		session[:my_filter_details_1] = params[:filter_details_1] if params[:filter_details_1]
		session[:my_filter_details_2] = params[:filter_details_2] if params[:filter_details_2]

    @details = Detail.getmydetails(@user.id,session,@cur_page)

		respond_to do |format|
			format.html
		 	format.xml { render :xml => @details.to_xml }
		end
  end
	
  def populate_filters
		session[:my_filter_by] = params[:filter_by] if params[:div] == 'my' 
		session[:wanted_filter_by] = params[:filter_by] if params[:div] == 'wanted' 
		@filter_by = params[:filter_by]

    @myfilters = MyFilter.getfilters(@filter_by)

		respond_to do |format|
			format.html
		 	format.xml { render :xml => @myfilters.to_xml }
		end
  end

	def get_wanted_albums
		@cur_page = params[:page]
		session[:wanted_sort_by] = params[:sort_by] if params[:sort_by]
		session[:wanted_type] = params[:wanted_type] if params[:wanted_type]
		session[:wanted_filter_by] = params[:filter_by] if params[:filter_by]
		session[:wanted_filter_details_1] = params[:filter_details_1] if params[:filter_details_1]
		session[:wanted_filter_details_2] = params[:filter_details_2] if params[:filter_details_2]

    @details = Detail.getwanteddetails(@user.id,session,@cur_page)

		respond_to do |format|
			format.html
		 	format.xml { render :xml => @details.to_xml }
		end
	end

	def get_friends_stats
		@all_stats = Array.new
		@fb_all = FBUtils.get_friends(@graph)
		@fb_all.each do |fb_user|
			# @all_stats << Stats.new("FBUser",fb_user.id)
			@all_stats << Stats.new(fb_user)
		end

		respond_to do |format|
      format.html
		 	format.xml { render :xml => @all_stats.to_xml }
		end
	end

	def downloadable_list

    @details = Detail.getwanteddetails(@user.id,session,@cur_page,true)

		respond_to do |format|
			format.html
		 	format.xml { render :xml => @details.to_xml }
		end
	end
end
