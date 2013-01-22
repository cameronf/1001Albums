class MessagingController < ApplicationController
	require ('albums_publisher.rb')

	def test_profile
   	AlbumsPublisher.deliver_profile_for_user(@fb_user)
   	redirect_to(:action => "profile")
	end
end

