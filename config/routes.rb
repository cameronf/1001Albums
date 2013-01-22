I00IAlbums::Application.routes.draw do
# ActionController::Routing::Routes.draw do |map|
  match 'newuser' => 'main#newuser'
  match 'login' => 'main#login'
	match 'new_entry' => 'main#new_entry'
	match 'showmyalbumstab' => 'main#showmyalbumstab'
	match 'showwantedtab' => 'main#showwantedtab'
	match 'showinvitetab' => 'main#showinvitetab'
	match 'showstatstab' => 'main#showstatstab'
	match 'showleaderstab' => 'main#showleaderstab'
	match 'iframeothersalbumstab' => 'main#iframeothersalbumstab'
	match 'iframewantedtab' => 'main#iframewantedtab'
	match 'iframemyalbumstab' => 'main#iframemyalbumstab'
	match 'showothersalbumstab' => 'main#showothersalbumstab'
	match 'fbremove' => 'admin#fbremove'
	match 'fb_register_feed' => 'admin#fb_register_feed'
	match 'allusers' => 'main#allusers'

  root :to => 'main#index'

	# resources :ltrs

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  match 'ltrs/(:action)' => 'ltrs#:action'
=begin
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
	map.connect '*anything' => 'errorhandler#unknownaction'
=end
end
