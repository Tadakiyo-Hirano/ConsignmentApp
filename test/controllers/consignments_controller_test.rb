require 'test_helper'

class ConsignmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get consignments_new_url
    assert_response :success
  end

end
