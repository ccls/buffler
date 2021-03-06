ActionController::Routing::Routes.draw do |map|

#	from calnet_authenticated
	map.logout 'logout', :controller => 'sessions', :action => 'destroy'
	map.resources :users, :only => [:destroy,:show,:index],
		:collection => { :menu => :get } do |user|
		user.resources :roles, :only => [:update,:destroy]
	end
	map.resource :session, :only => [ :destroy ]

	map.resources :locales, :only => :show

	map.resources :pages, :collection => { 
		:all => :get,
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
