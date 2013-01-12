class MessagingController < ApplicationController
  before_filter :ensure_application_is_installed_by_facebook_user
  before_filter :ensure_authenticated_to_facebook
  before_filter :get_user

	require ('albums_publisher.rb')


  def get_user
    @fb_user = session[:facebook_session].user
    @user = User.find_by_fb_user_id(@fb_user.id)
    @fb_friends = @fb_user.friends_with_this_app
    @fb_all = [@fb_user] + @fb_friends
  end

	def test_profile
   	AlbumsPublisher.deliver_profile_for_user(@fb_user)
   	redirect_to(:action => "profile")
	end
end

