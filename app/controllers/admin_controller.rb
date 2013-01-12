class AdminController < ApplicationController
	require ('albums_publisher.rb')
	def fbremove
		User.deleteuser(params[:fb_sig_user])
	end

	def fb_register_feed
		AlbumsPublisher.register_mini_feed
	  render :text => "Registered Feed", :layout => false
	end
end
