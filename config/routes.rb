ActionController::Routing::Routes.draw do |map|

	map.resources :pages, :collection => { 
		:all => :get,
		:translate => :get,
		:order => :post }

	map.root :controller => "pages", :action => "show", :path => [""]

	map.resource  :calendar,   :only => [ :show ]

	map.resources :photos

	map.resources :home_page_pics, :collection => { 
		:random => :get,
		:activate => :post }

	#	MUST BE LAST OR WILL BLOCK ALL OTHER ROUTES!
	#	catch all route to manage admin created pages.
	map.connect   '*path', :controller => 'pages', :action => 'show'

end
