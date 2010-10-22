#require 'page'
module ApplicationHelper

	def application_root_menu
		#<%# Page changes outside of ActionController go unnoticed %>
		#<%# Due to the variability of the menu, we can't really cache it %>
		#<%# cache 'page_menu' do %>
		roots = Page.roots
		count = roots.length
		count = ( count > 0 ) ? count : 1 
		width = ( 900 - count ) / count
		s = "<div id='rootmenu' class='main_width'>\n"
		roots.each do |page|
			s << link_to( "&nbsp;",	#page.menu(session[:locale]), 
				ActionController::Base.relative_url_root.to_s + page.path,
				:id => "menu_#{dom_id(page)}",
				:style => "width: #{width}px",
				:class => ((page == @page.try(:root))?'current':nil))
			s << "\n"
		end
		s << "</div><!-- id='rootmenu' -->\n"
	end

	def application_sub_menu
		if @page && !@page.root.children.empty?
			s = "<div id='submenu' class='main_width'>\n"
			s << "<div id='current_root'>"
			s << @page.root.menu(session[:locale])
			s << "</div>\n"
			s << "<div id='children'>\n"
			@page.root.children.each do |child|
				s << "<span class='child#{(@page==child)?" current_child":""}'>"
				s << link_to( child.menu(session[:locale]), 
					ActionController::Base.relative_url_root.to_s + child.path,
					:id => "menu_#{dom_id(child)}" )
				s << "</span>\n"
			end
			s << "</div><!-- id='children'  -->\n"
			s << "</div><!-- id='submenu'  -->\n"
		end
	end

	def application_home_page_pic
		if @page && @page.is_home? 
			s =  "<div id='home_page_pic' class='main_width'>\n"
			s << image_tag( @hpp.image.url(:full) ) if !@hpp.nil?
			s << "\n</div><!-- id='home_page_pic'  -->\n"
		end
	end

	def footer_menu
		s = "<div class='main_width'><p>\n"
		l = []
		l.push(link_to( 'Pages', pages_path ))
		l.push(link_to( 'Calendar', calendar_path ))
		l.push(link_to( 'Users', users_path ))
		l.push(link_to( 'HomePagePics', home_page_pics_path ))
#		if logged_in? 
#			l.push(link_to( "My Account", user_path(current_user) ))
#			l.push(link_to( "Logout", logout_path ))
#		end
		s << l.join("&nbsp;|&nbsp;\n")
		s << "<a id='user_links'></a>"
		s << "</p></div>\n"
	end

	def footer_sub_menu
		s = "<div class='main_width'><p>\n"
		l = ["<span>Copyright &copy; UC Regents; all rights reserved.</span>"]
		Page.hidden.each do |page|
			l.push(link_to( page.menu(session[:locale]), 
				ActionController::Base.relative_url_root.to_s + page.path ))
		end

		#	AJAXify these locale links are there is no need
		#	for a full link.  Update the session on the server
		#	and then translate all of the translatables.

		if session[:locale] && session[:locale] == 'es'
			l.push(link_to( 'English', locale_path('en'),
				:id => 'session_locale' ))
		else
			l.push(link_to( 'Espa&ntilde;ol', locale_path('es'),
				:id => 'session_locale' ))
		end
		s << l.join("&nbsp;|&nbsp;\n")
		s << "</p></div>\n"
	end

end
