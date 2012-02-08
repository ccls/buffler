class HomePagePicsController < ApplicationController

	skip_before_filter :login_required, :only => :random
	ssl_allowed :random

	before_filter :may_edit_required, :except => :random
#	before_filter :may_edit_required	#, :only => :activate

#	before_filter :may_create_home_page_pics_required,
#		:only => [:new,:create]
#	before_filter :may_read_home_page_pics_required,
#		:only => [:show,:index]
#	before_filter :may_update_home_page_pics_required,
#		:only => [:edit,:update]
#	before_filter :may_destroy_home_page_pics_required,
#		:only => :destroy

	before_filter :valid_id_required, 
		:only => [:show,:edit,:update,:destroy]


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


	def index
		@home_page_pics = HomePagePic.all
	end

	def new
		@home_page_pic = HomePagePic.new
	end

	def create
		@home_page_pic = HomePagePic.new(params[:home_page_pic])
		@home_page_pic.save!
		flash[:notice] = 'Success!'
		redirect_to @home_page_pic
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the home_page_pic"
		render :action => "new"
	end 

	def update
		@home_page_pic.update_attributes!(params[:home_page_pic])
		flash[:notice] = 'Success!'
		redirect_to home_page_pics_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the home_page_pic"
		render :action => "edit"
	end

	def destroy
		@home_page_pic.destroy
		redirect_to home_page_pics_path
	end

protected

	def valid_id_required
		if( !params[:id].blank? && HomePagePic.exists?(params[:id]) )
			@home_page_pic = HomePagePic.find(params[:id])
		else
			access_denied("Valid id required!", home_page_pics_path)
		end
	end

end

__END__


	resourceful

	skip_before_filter :login_required, :only => :random
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

__END__

#	removed method
#	skip_before_filter :build_menu_js, :only => :random
