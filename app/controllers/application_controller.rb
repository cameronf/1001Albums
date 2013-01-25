# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :authenticate_with_fb, :except => :login
	before_filter :global_filter

  def authenticate_with_fb
    @oauth = Koala::Facebook::OAuth.new
    # This stuff seems completely horked, but if my logic is right,
    # First, see if there is a user already logged in with the current session
    # and if so, test that we can get to FB
    session["fb_id"] ||= params[:fb_id]
    @user = User.find_by_fb_user_id(session["fb_id"]) unless session["fb_id"].nil?

    # I don't like this, but it seems like the way Koala wants to fail is to
    # throw an exception
    begin 
      @graph = Koala::Facebook::GraphAPI.new(@user.access_token)  
    rescue
      logger.info cookies.inspect
      @facebook_cookies ||= @oauth.get_user_info_from_cookies(cookies)
      logger.info @facebook_cookies
      if @facebook_cookies
        @user = User.find_by_fb_user_id(@facebook_cookies["user_id"])
        @access_token = @oauth.exchange_access_token(@facebook_cookies["access_token"])
        @user.update_attributes({ :session_id => request.session["session_id"], 
                                  :access_token => @access_token})
        @graph = Koala::Facebook::GraphAPI.new(@user.access_token)
        session["fb_id"] = @user.fb_user_id
      else
        redirect_to :controller => :main, :action => :login
      end
    end
    if @graph
      @fb_user = @graph.get_object("me")
      logger.info @fb_user
    end
  end

	def global_filter
		@DEBUG = false
		response.headers['P3P'] = 'CP="CAO PSA OUR"'
	end

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '51ea340fe2830836a98ce7786a927099'

  def method_missing(methondname, *args)
    redirect_to :controller => "errorhandler", :action => "unknownaction"
  end

  def show_env_in_debugger
    if request.xml_http_request?()
      str="AJAX Request\n"
    else
      str="";
    end

    request.env(  ).each do |key,value|
      str+=key.to_s + "==" + value.to_s+"\n"
    end

    logger.debug str
  end

end

$APP_ROOT = "http://1001Albums.fisheyedev.com/"
$FB_APP_ROOT = "http://apps.new.facebook.com/iooialbums"
#$FB_APP_ROOT = "http://1001Albums.fisheyedev.com"
$RATING_WIDTH = 24
$RATING_HEIGHT = 24
$FORMAT_WIDTH = 24
$FORMAT_HEIGHT = 24

$SORT_KEY = ['album_id ASC', 'albums.sortname ASC, album_id ASC', 'rating DESC, album_id ASC']
$FILTER_BY = ['','artist','title','year','format','owned','heard']
