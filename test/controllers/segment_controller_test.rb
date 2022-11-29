require "test_helper"

class SegmentControllerTest < ActionDispatch::IntegrationTest
  test "should get input" do
    get segment_input_url
    assert_response :success
  end

  test "should get result" do
    get segment_result_url
    assert_response :success
  end
end
