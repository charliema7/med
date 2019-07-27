require 'test_helper'

class LoginActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get login_activities_index_url
    assert_response :success
  end

end
