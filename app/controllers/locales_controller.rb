class LocalesController < ApplicationController

	skip_before_filter :login_required

	def show
		session[:locale] = params[:id]
		redirect_to_referer_or_default(root_path)
	end

end

__END__

#	removed method
#	skip_before_filter :build_menu_js

	def show
		session[:locale] = params[:id]
		respond_to do |format|
			format.html { redirect_to_referer_or_default(root_path) }
# format.js {}
			format.js { render :text => "locale = '#{session[:locale]}'" }
		end
	end

end
