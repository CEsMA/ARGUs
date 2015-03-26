require File.dirname(__FILE__) + '/../test_helper'
require 'unidad_controller'

# Re-raise errors caught by the controller.
class UnidadController; def rescue_action(e) raise e end; end

class UnidadControllerTest < Test::Unit::TestCase
  fixtures :unidads

  def setup
    @controller = UnidadController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = unidads(:first).id
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

    assert_not_nil assigns(:unidads)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:unidad)
    assert assigns(:unidad).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:unidad)
  end

  def test_create
    num_unidads = Unidad.count

    post :create, :unidad => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_unidads + 1, Unidad.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:unidad)
    assert assigns(:unidad).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Unidad.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Unidad.find(@first_id)
    }
  end
end
