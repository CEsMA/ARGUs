require File.dirname(__FILE__) + '/../test_helper'
require 'solicitude_controller'

# Re-raise errors caught by the controller.
class SolicitudeController; def rescue_action(e) raise e end; end

class SolicitudeControllerTest < Test::Unit::TestCase
  fixtures :solicitudes

  def setup
    @controller = SolicitudeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = solicitudes(:first).id
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

    assert_not_nil assigns(:solicitudes)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:solicitude)
    assert assigns(:solicitude).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:solicitude)
  end

  def test_create
    num_solicitudes = Solicitude.count

    post :create, :solicitude => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_solicitudes + 1, Solicitude.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:solicitude)
    assert assigns(:solicitude).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Solicitude.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Solicitude.find(@first_id)
    }
  end
end
