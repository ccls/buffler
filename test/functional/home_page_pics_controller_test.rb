require 'test_helper'

class HomePagePicsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'HomePagePic',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}

	def factory_attributes(options={})
		Factory.attributes_for(:home_page_pic,options)
	end
	def factory_create(options={})
		Factory(:home_page_pic,options)
	end

	assert_access_with_login(   { :logins => site_editors })
	assert_no_access_with_login({ :logins => non_site_editors })
	assert_no_access_without_login

	assert_access_with_https 
	assert_no_access_with_http 

	site_editors.each do |cu|
	
		test "should NOT create home_page_pic without valid HPP with #{cu} login" do
			login_as send(cu)
			assert_difference('HomePagePic.count',0) do
				post :create, :home_page_pic => { }
			end
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end
	
		test "should NOT update home_page_pic when update fails with #{cu} login" do
			hpp = Factory(:home_page_pic)
			HomePagePic.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			put :update, :id => hpp.id,
				:home_page_pic => Factory.attributes_for(:home_page_pic)
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'edit'
		end
	
	#	activate
	
		test "should activate all with #{cu} login" do
			login_as send(cu)
			hpp1 = Factory(:home_page_pic, :active => false)
			hpp2 = Factory(:home_page_pic, :active => false)
			HomePagePic.all.each { |hpp| assert !hpp.active }
			post :activate, :home_page_pics => {
				hpp1.id => { 'active' => true },
				hpp2.id => { 'active' => true }
			}
			HomePagePic.all.each { |hpp| assert hpp.active }
		end
	
		test "should deactivate all with #{cu} login" do
			login_as send(cu)
			hpp1 = Factory(:home_page_pic, :active => true)
			hpp2 = Factory(:home_page_pic, :active => true)
			HomePagePic.all.each { |hpp| assert hpp.active }
			post :activate, :home_page_pics => {
				hpp1.id => { 'active' => false },
				hpp2.id => { 'active' => false }
			}
			HomePagePic.all.each { |hpp| assert !hpp.active }
			assert_redirected_to home_page_pics_path
		end
	
		test "should NOT activate all when save fails with #{cu} login" do
			login_as send(cu)
			hpp1 = Factory(:home_page_pic, :active => false)
			hpp2 = Factory(:home_page_pic, :active => false)
			HomePagePic.all.each { |hpp| assert !hpp.active }
			HomePagePic.any_instance.stubs(:create_or_update).returns(false)
			post :activate, :home_page_pics => {
				hpp1.id => { 'active' => true },
				hpp2.id => { 'active' => true }
			}
			HomePagePic.all.each { |hpp| assert !hpp.active }
			assert_redirected_to home_page_pics_path
			assert_not_nil flash[:error]
		end
	
	end
	
	non_site_editors.each do |cu|
	
		test "should NOT activate all with #{cu} login" do
			login_as send(cu)
			hpp1 = Factory(:home_page_pic, :active => false)
			hpp2 = Factory(:home_page_pic, :active => false)
			HomePagePic.all.each { |hpp| assert !hpp.active }
			post :activate, :home_page_pics => {
				hpp1.id => { 'active' => true },
				hpp2.id => { 'active' => true }
			}
			HomePagePic.all.each { |hpp| assert !hpp.active }
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end
	
	end

	test "should NOT activate all without login" do
		hpp1 = Factory(:home_page_pic, :active => false)
		hpp2 = Factory(:home_page_pic, :active => false)
		HomePagePic.all.each { |hpp| assert !hpp.active }
		post :activate, :home_page_pics => {
			hpp1.id => { 'active' => true },
			hpp2.id => { 'active' => true }
		}
		HomePagePic.all.each { |hpp| assert !hpp.active }
		assert_redirected_to_login
	end

	test "should get random via js without login or home page pics" do
		@request.accept = "text/javascript"
		get :random
		assert_response :success
		assert_match /\A\s*\z/, @response.body
	end

	test "should get random via js with home page pic and without login" do
		Factory(:home_page_pic,:image_file_name => "somethingbogus.jpg")
		@request.accept = "text/javascript"
		get :random
		assert_response :success
		assert_match /jQuery/, @response.body

#jQuery(function(){
#jQuery('#home_page_pic').html('<img alt="Somethingbogus" src="/test/system/images/1/full/somethingbogus.jpg" />')
#});

	end

end
