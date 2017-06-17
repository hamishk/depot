require 'test_helper'

class DebugControllerTest < ActionDispatch::IntegrationTest
  test "should get update_session" do
    get debug_update_session_url
    assert_response :success
  end

end
