require File.dirname(__FILE__) + '/../test_helper'

class IconsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:icons)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_icon
    assert_difference('Icon.count') do
      post :create, :icon => { }
    end

    assert_redirected_to icon_path(assigns(:icon))
  end

  def test_should_show_icon
    get :show, :id => icons(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => icons(:one).id
    assert_response :success
  end

  def test_should_update_icon
    put :update, :id => icons(:one).id, :icon => { }
    assert_redirected_to icon_path(assigns(:icon))
  end

  def test_should_destroy_icon
    assert_difference('Icon.count', -1) do
      delete :destroy, :id => icons(:one).id
    end

    assert_redirected_to icons_path
  end
end
