require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @published_post = posts(:published_post)
    @draft_post = posts(:draft_post)
    setup_inertia_rendering
  end

  test "index renders Posts/Index component" do
    get posts_path

    assert_response :success
    assert_inertia_component "Posts/Index"
    assert_inertia_props_include :posts, :pagination, :filters
  end

  test "index returns correct props structure" do
    get posts_path

    assert_response :success
    assert inertia.props["posts"].is_a?(Array)
    assert inertia.props["pagination"].key?("page")
    assert inertia.props["filters"].key?("search")
  end

  test "show renders Posts/Show component with post" do
    get post_path(@published_post)

    assert_response :success
    assert_inertia_component "Posts/Show"
    assert_equal @published_post.id, inertia.props["post"]["id"]
    assert_equal @published_post.title, inertia.props["post"]["title"]
  end

  test "new renders Posts/New component" do
    get new_post_path

    assert_response :success
    assert_inertia_component "Posts/New"
  end

  test "create redirects on success" do
    assert_difference("Post.count", 1) do
      post posts_path, params: { post: { title: "New Post", body: "Content here" } }
    end

    assert_redirected_to posts_path
  end

  test "edit renders Posts/Edit component" do
    get edit_post_path(@published_post)

    assert_response :success
    assert_inertia_component "Posts/Edit"
    assert_equal @published_post.id, inertia.props["post"]["id"]
  end

  test "destroy removes post" do
    assert_difference("Post.count", -1) do
      delete post_path(@draft_post)
    end

    assert_redirected_to posts_path
  end
end
