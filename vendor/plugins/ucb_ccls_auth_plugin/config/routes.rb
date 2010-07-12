ActionController::Routing::Routes.draw do |map|
	map.logout 'logout', :controller => 'sessions', :action => 'destroy'
	map.resources :sessions, :only => [ :destroy ]
	map.resources :users, :only => [:show, :index] do |user|
		user.resources :roles, :only => [:update,:destroy]
	end
end
