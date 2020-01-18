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
    user_identifier = '4623ed17-6750-4357-9d73-7ac5591761af'
    rollout.activate_user(:burritos, user_identifier)
    get '/rollout/features'
    assert_response :success
    features_json = last_json
    assert_equal 2, features_json.size
    burritos_json = {
      'name' => 'burritos',
      'percentage' => 50,
      'groups' => ['burrito_lovers'],
      'users' => [user_identifier],
    }
    assert features_json.include?(kittens_json)
    assert features_json.include?(burritos_json)
  end

  test "show feature" do
    rollout.activate(:kittens)
    get '/rollout/features/kittens'
    assert_response :success
    feature_data = { 'name' => 'kittens', 'percentage' => 100, 'groups' => [], 'users' => [] }
    assert_equal feature_data, last_json

    rollout.activate_percentage(:kittens, 75)
    get '/rollout/features/kittens'
    assert_response :success
    feature_data['percentage'] = 75
    assert_equal feature_data, last_json

    user_identifier = '80a8d952-23b3-4b21-8412-5e58e717771c'
    rollout.activate_user(:kittens, user_identifier)
    get '/rollout/features/kittens'
    assert_response :success
    feature_data['users'] << user_identifier
    assert_equal feature_data, last_json
  end

  test "update feature percentage" do
    rollout.activate(:kittens)
    patch '/rollout/features/kittens', params: { percentage: '65' }
    assert_response :success
    assert_equal 65, rollout.get(:kittens).percentage
  end

  test "update feature data" do
    rollout.activate(:kittens)
    patch '/rollout/features/kittens', params: { percentage: '65', data: { foo: 'bar' } }
    assert_response :success
    feature = rollout.get(:kittens)
    assert_equal({ 'foo' => 'bar' }, feature.data)
    assert_equal(65, feature.percentage)
  end

  test "add group to feature" do
    rollout.deactivate(:extra_sharp_knives)
    post '/rollout/features/extra_sharp_knives/groups', params: { group: 'experienced_chefs' }
    assert_equal 0, rollout.get(:extra_sharp_knives).percentage
    assert_equal [:experienced_chefs], rollout.get(:extra_sharp_knives).groups
  end

  test "attempt to add group to feature without a group name" do
    rollout.deactivate(:extra_sharp_knives)
    post '/rollout/features/extra_sharp_knives/groups'
    assert_response 400
    assert_equal [], rollout.get(:extra_sharp_knives).groups
  end

  test "remove group from feature" do
    rollout.deactivate(:extra_sharp_knives)
    rollout.activate_group(:extra_sharp_knives, :experienced_chefs)
    delete '/rollout/features/extra_sharp_knives/groups/experienced_chefs', as: :json
    assert_equal 0, rollout.get(:extra_sharp_knives).percentage
    assert_equal [], rollout.get(:extra_sharp_knives).groups
  end

  test "add user to feature" do
    rollout.deactivate(:potato_gun)
    user_identifier = '407f7944-af76-4ee0-bed8-8d3ce2d33916'
    post '/rollout/features/potato_gun/users', params: { user_id: user_identifier }
    assert_equal 0, rollout.get(:potato_gun).percentage
    assert_equal [user_identifier], rollout.get(:potato_gun).users
    assert rollout.active?(:potato_gun, user_identifier)
  end

  test "attempt to activate user to feature without a user id" do
    rollout.deactivate(:potato_gun)
    post '/rollout/features/potato_gun/users'
    assert_response 400
    assert_equal [], rollout.get(:potato_gun).users
  end

  test "remove user from feature" do
    rollout.deactivate(:potato_gun)
    user_identifier = '54d5448d-f973-4afc-9084-052024669415'
    rollout.activate_user(:potato_gun, user_identifier)
    assert rollout.active?(:potato_gun, user_identifier)

    delete "/rollout/features/potato_gun/users/#{user_identifier}"

    assert_equal 0, rollout.get(:potato_gun).percentage
    assert_equal [], rollout.get(:potato_gun).groups
    refute rollout.active?(:potato_gun, user_identifier)
  end

  test "deletes a feature" do
    rollout.delete(:potato_gun)
    delete '/rollout/features/potato_gun'
    assert_equal [], rollout.get(:potato_gun).users
    assert_equal [], rollout.get(:potato_gun).groups
    refute rollout.active?(:potato_gun)
  end

  test "protect API with basic auth" do
    with_protected_app do
      get '/rollout/features'
    end
    assert_response :unauthorized
  end

  test "can login with configured username and password" do
    with_protected_app do
      get '/rollout/features', headers: env_with_basic_auth
    end
    assert_response :success
  end

  test "unset basic auth username and password does not allow login" do
    with_protected_app do
      RolloutControl.basic_auth_username = ''
      RolloutControl.basic_auth_password = ''
      get '/rollout/features', headers: env_with_basic_auth
    end
    assert_response :unauthorized
  end

  private

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
