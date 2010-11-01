require File.dirname(__FILE__) + '/../test_helper'

class HomePagePicTest < ActiveSupport::TestCase

	assert_should_require(:title)
	assert_should_require_attribute_length(:title,:minimum => 4)

	test "should create home_page_pic" do
		assert_difference 'HomePagePic.count' do
			@object = create_object
			assert !@object.new_record?, 
				"#{@object.errors.full_messages.to_sentence}"
		end
		@object.destroy
	end

	test "should return random HPP" do
		active   = Factory(:home_page_pic, :active => true, 
			:image_file_name => 'some_fake_file_name')
		inactive = Factory(:home_page_pic, :active => false, 
			:image_file_name => 'some_fake_file_name')
		assert_equal active, HomePagePic.random_active()
		active.destroy
		inactive.destroy
	end

protected

	def create_object(options = {})
		record = Factory.build(:home_page_pic,options)
		record.save
		record
	end

end
