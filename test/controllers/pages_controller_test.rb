require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get vuetify_test" do
    get pages_vuetify_test_url
    assert_response :success
  end
end
