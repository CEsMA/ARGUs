require File.dirname(__FILE__) + '/../test_helper'
require 'areainterese_controller'

# Re-raise errors caught by the controller.
class AreaintereseController; def rescue_action(e) raise e end; end

class AreaintereseControllerTest < Test::Unit::TestCase
  fixtures :areaintereses

  def setup
    @controller = AreaintereseController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = areaintereses(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:areaintereses)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:areainterese)
    assert assigns(:areainterese).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:areainterese)
  end

  def test_create
    num_areaintereses = Areainterese.count

    post :create, :areainterese => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_areaintereses + 1, Areainterese.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:areainterese)
    assert assigns(:areainterese).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Areainterese.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Areainterese.find(@first_id)
    }
  end
end
