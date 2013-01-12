# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
	before_filter :global_filter

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
