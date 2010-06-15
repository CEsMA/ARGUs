require File.dirname(__FILE__) + '/../test_helper'
require 'requerimiento_controller'

# Re-raise errors caught by the controller.
class RequerimientoController; def rescue_action(e) raise e end; end

class RequerimientoControllerTest < Test::Unit::TestCase
  fixtures :requerimientos

  def setup
    @controller = RequerimientoController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = requerimientos(:first).id
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

    assert_not_nil assigns(:requerimientos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:requerimiento)
    assert assigns(:requerimiento).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:requerimiento)
  end

  def test_create
    num_requerimientos = Requerimiento.count

    post :create, :requerimiento => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_requerimientos + 1, Requerimiento.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:requerimiento)
    assert assigns(:requerimiento).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Requerimiento.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Requerimiento.find(@first_id)
    }
  end
end
