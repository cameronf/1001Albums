# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :authenticate_with_fb, :except => :login
	before_filter :global_filter

  def authenticate_with_fb
    @oauth = Koala::Facebook::OAuth.new
    session["fb_id"] = params["fb_id"] unless params[:fb_id].nil?
    @user = User.find_by_fb_user_id(session["fb_id"]) if session["fb_id"]
    @graph = safe_koala_graph_new(@user.access_token) if @user

    if @graph.nil?
      @facebook_cookies = safe_oauth_get_user_info_from_cookies(@oauth,cookies)
      if @facebook_cookies
        @user = User.find_by_fb_user_id(@facebook_cookies["user_id"]) unless @facebook_cookies["user_id"].nil?
        @user = User.adduser(@facebook_cookies["user_id"]) if @user.nil?
        @access_token = @oauth.exchange_access_token(@facebook_cookies["access_token"])
        @user.update_attributes({ :session_id => request.session["session_id"], 
                                  :access_token => @access_token})
        @graph = safe_koala_graph_new(@user.access_token)
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
  # protect_from_forgery :secret => '51ea340fe2830836a98ce7786a927099'

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

  private
  
  def safe_koala_graph_new(access_token)
    begin
      Koala::Facebook::GraphAPI.new(access_token)  
    rescue
      ''
    end
  end

  def safe_oauth_get_user_info_from_cookies(oauth,cookies)
    begin
      oauth.get_user_info_from_cookies(cookies)
    rescue
      ''
    end
  end
end

$RATING_WIDTH = 24
$RATING_HEIGHT = 24
$FORMAT_WIDTH = 24
$FORMAT_HEIGHT = 24
