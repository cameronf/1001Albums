ActionController::Routing::Routes.draw do |map|
	map.newuser 'newuser', :controller => 'main', :action => 'newuser'
	map.new_entry 'new_entry', :controller => 'main', :action => 'new_entry'
	map.showmyalbumstab 'showmyalbumstab', :controller => 'main', :action => 'showmyalbumstab'
	map.showwantedtab 'showwantedtab', :controller => 'main', :action => 'showwantedtab'
	map.showinvitetab 'showinvitetab', :controller => 'main', :action => 'showinvitetab'
	map.showstatstab 'showstatstab', :controller => 'main', :action => 'showstatstab'
	map.showleaderstab 'showleaderstab', :controller => 'main', :action => 'showleaderstab'
	map.iframeothersalbumstab 'iframeothersalbumstab', :controller => 'main', :action => 'iframeothersalbumstab'
	map.iframewantedtab 'iframewantedtab', :controller => 'main', :action => 'iframewantedtab'
	map.iframemyalbumstab 'iframemyalbumstab', :controller => 'main', :action => 'iframemyalbumstab'
	map.showothersalbumstab 'showothersalbumstab', :controller => 'main', :action => 'showothersalbumstab'
	map.fbremove 'fbremove', :controller => 'admin', :action => 'fbremove'
	map.fb_register_feed 'fb_register_feed', :controller => 'admin', :action => 'fb_register_feed'
	map.allusers 'allusers', :controller => 'main', :action => 'allusers'
  map.root :controller => "main"
	map.resources :ltrs

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
	map.connect '*anything', :controller => 'errorhandler', :action => 'unknownaction'
end
