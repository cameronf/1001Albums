class AlbumsPublisher < Facebooker::Rails::Publisher
	def mini_feed_template
		one_line_story_template("{*actor*} just listened to {*one_line_detail_string*}")
		full_story_template("{*actor*} just listened to {*short_title_string*}","{*album_image*} {*album_info*} Check out {*app_link*}")
	end

	def mini_feed(user,detail,heard_count)
		send_as :user_action
		from(user)
		data ({
			:one_line_detail_string => "#{fb_pronoun(user, {:use_you => false, :possessive => true})} #{heard_count}th album - #{detail.album.title} by #{detail.album.artist}.",
			:short_title_string => "#{fb_pronoun(user, {:use_you => false, :possessive => true})} #{heard_count}th album.",
			:album_info => "<b>#{detail.album.artist}<br>#{detail.album.title} (#{detail.album.year}).<br><br><br><br><br></b>",
			:album_image => "<img align=\"left\" hspace=\"10px\" alt=\"#{detail.album.id}\" src=\"#{$APP_ROOT}images/#{detail.album.id}.jpg\"/>", 
			:app_link => link_to("1001 Albums You Must Hear Before You Die", showmyalbumstab_url)
		})
	end

	def profile_for_user(user_to_update, detail, stats)
		send_as :profile
		from user_to_update
  	recipients user_to_update
  	fbml = render(:partial => "messaging/user_profile.fbml.erb", :locals => {:fb_user => user_to_update, :detail => detail, :stats => stats} )
  	profile(fbml)
		profile_main(fbml)
	end
end
