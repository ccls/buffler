require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  def setup
    @request  = ActionController::TestRequest.new
#    @response = ActionController::TestResponse.new
  end

	test "should respond_to application_root_menu" do
		assert respond_to?(:application_root_menu)
	end
	
	test "should respond_to application_sub_menu" do
		assert respond_to?(:application_sub_menu)
	end
	
	test "should respond_to application_home_page_pic" do
		assert respond_to?(:application_home_page_pic)
	end
	
	test "should respond_to footer_menu" do
		assert respond_to?(:footer_menu)
	end
	
	test "should respond_to footer_sub_menu" do
		assert respond_to?(:footer_sub_menu)
	end

	test "application_sub_menu should return nothing without @page" do
		response = application_sub_menu
		assert response.blank?
	end
	
	test "application_sub_menu should return nothing without @page.children" do
		@page = create_page
		response = application_sub_menu
		assert response.blank?
	end
	
	test "application_sub_menu should return submenu with @page.children" do
		@page = create_page
		@page.children << create_page
		response = application_sub_menu
		assert !response.blank?
	end

	test "footer_sub_menu should return footer" do
		response = footer_sub_menu
		assert !response.blank?
#		html = HTML::Document.new(response).root
#		assert_select response, 'ul#PrivateNav', 1 do
#			assert_select 'li', 5
#		end
	end
	
	test "footer_sub_menu should return footer without locale" do
		response = footer_sub_menu
		assert !response.blank?
#		html = HTML::Document.new(response).root
#		assert_select response, 'ul#PrivateNav', 1 do
#			assert_select 'li', 5
#		end
	end
	
	test "footer_sub_menu should return footer with 'es' locale" do
		session[:locale] = 'es'
		response = footer_sub_menu
		assert !response.blank?
#		html = HTML::Document.new(response).root
#		assert_select response, 'ul#PrivateNav', 1 do
#			assert_select 'li', 5
#		end
	end
	
	test "footer_sub_menu should return footer with 'en' locale" do
		session[:locale] = 'en'
		response = footer_sub_menu
		assert !response.blank?
#		html = HTML::Document.new(response).root
#		assert_select response, 'ul#PrivateNav', 1 do
#			assert_select 'li', 5
#		end
	end
	
end
