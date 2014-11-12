require 'test_helper'

class RolloutControlTest < ActionDispatch::IntegrationTest
  test "list empty features" do
    get '/rollout/features'
    assert_response :success
    assert_equal [], last_json
  end

  test "list existing features" do
    rollout.activate(:kittens)
    get '/rollout/features'
    assert_response :success
    kittens_json = { 'name' => 'kittens', 'percentage' => 100, 'groups' => [], 'users' => [] }
    assert_equal [kittens_json], last_json

    rollout.activate_percentage(:burritos, 50)
    rollout.activate_group(:burritos, :burrito_lovers)
    rollout.activate_user(:burritos, user(35))
    get '/rollout/features'
    assert_response :success
    features_json = last_json
    assert_equal 2, features_json.size
    burritos_json = { 'name' => 'burritos', 'percentage' => 50, 'groups' => ['burrito_lovers'], 'users' => ['35'] }
    assert features_json.include?(kittens_json)
    assert features_json.include?(burritos_json)
  end

  test "show feature" do
    rollout.activate(:kittens)
    get '/rollout/features/kittens'
    assert_response :success
    feature_data = { 'percentage' => 100, 'groups' => [], 'users' => [] }
    assert_equal feature_data, last_json

    rollout.activate_percentage(:kittens, 75)
    get '/rollout/features/kittens'
    assert_response :success
    feature_data['percentage'] = 75
    assert_equal feature_data, last_json

    rollout.activate_user(:kittens, OpenStruct.new(id: 101))
    get '/rollout/features/kittens'
    assert_response :success
    feature_data['users'] << '101'
    assert_equal feature_data, last_json
  end

  test "update feature percentage" do
    rollout.activate(:kittens)
    patch '/rollout/features/kittens', { percentage: '65' }
    assert_response :success
    assert_equal 65, rollout.get(:kittens).percentage
  end

  test "add group to feature" do
    rollout.deactivate(:extra_sharp_knives)
    post 'rollout/features/extra_sharp_knives/groups', group: 'experienced_chefs'
    assert_equal 0, rollout.get(:extra_sharp_knives).percentage
    assert_equal [:experienced_chefs], rollout.get(:extra_sharp_knives).groups
  end

  test "attempt to add group to feature without a group name" do
    rollout.deactivate(:extra_sharp_knives)
    post 'rollout/features/extra_sharp_knives/groups'
    assert_response 400
    assert_equal [], rollout.get(:extra_sharp_knives).groups
  end

  test "remove group from feature" do
    rollout.deactivate(:extra_sharp_knives)
    rollout.activate_group(:extra_sharp_knives, :experienced_chefs)
    delete 'rollout/features/extra_sharp_knives/groups/experienced_chefs'
    assert_equal 0, rollout.get(:extra_sharp_knives).percentage
    assert_equal [], rollout.get(:extra_sharp_knives).groups
  end

  test "add user to feature" do
    rollout.deactivate(:potato_gun)
    post 'rollout/features/potato_gun/users', user_id: 45
    assert_equal 0, rollout.get(:potato_gun).percentage
    assert_equal ['45'], rollout.get(:potato_gun).users
    assert rollout.active?(:potato_gun, user(45))
  end

  test "attempt to activate user to feature without a user id" do
    rollout.deactivate(:potato_gun)
    post 'rollout/features/potato_gun/users'
    assert_response 400
    assert_equal [], rollout.get(:potato_gun).users
  end

  test "remove user from feature" do
    rollout.deactivate(:potato_gun)
    rollout.activate_user(:potato_gun, user(45))
    delete 'rollout/features/potato_gun/users/45'
    assert_equal 0, rollout.get(:potato_gun).percentage
    assert_equal [], rollout.get(:potato_gun).groups
    refute rollout.active?(:potato_gun, user(45))
  end

  test "protect API with basic auth" do
    with_protected_app do
      get '/rollout/features'
    end
    assert_response :unauthorized
  end

  test "can login with configured username and password" do
    with_protected_app do
      get '/rollout/features', {}, env_with_basic_auth
    end
    assert_response :success
  end

  test "unset basic auth username and password does not allow login" do
    with_protected_app do
      RolloutControl.basic_auth_username = ''
      RolloutControl.basic_auth_password = ''
      get '/rollout/features', {}, env_with_basic_auth
    end
    assert_response :unauthorized
  end

  private

  def user(id)
    OpenStruct.new(id: id)
  end

  def rollout
    RolloutControl.rollout
  end

  def with_protected_app
    RolloutControl.unprotected = false
    RolloutControl.basic_auth_username = 'aaron'
    RolloutControl.basic_auth_password = 'changeme'
    yield
    RolloutControl.unprotected = true
  end

  def env_with_basic_auth(username = 'aaron', password = 'changeme')
    {
      'ACCEPT' => 'application/json',
      'HTTP_AUTHORIZATION' => "Basic #{Base64::encode64("#{username}:#{password}")}"
    }
  end
end
