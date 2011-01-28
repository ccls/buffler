class HomePagePicsController < ApplicationController

	resourceful

	skip_before_filter :login_required, :only => :random
	skip_before_filter :build_menu_js, :only => :random
	ssl_allowed :random

	before_filter :may_edit_required, :only => :activate

	def random
		respond_to do |format|
			format.js{}
		end
	end

	def activate
		#["1", {"active"=>"true"}]
		#["2", {"active"=>"false"}]
		params[:home_page_pics].each do |hpp|
			HomePagePic.find(hpp[0]).update_attributes!(
				:active => hpp[1]['active'])
		end
		flash[:notice] = "Active statuses updated."
	rescue
		flash[:error] = "Something bad happened?"
	ensure
		redirect_to home_page_pics_path
	end

end
