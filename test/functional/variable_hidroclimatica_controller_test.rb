require File.dirname(__FILE__) + '/../test_helper'
require 'variable_hidroclimatica_controller'

# Re-raise errors caught by the controller.
class VariableHidroclimaticaController; def rescue_action(e) raise e end; end

class VariableHidroclimaticaControllerTest < Test::Unit::TestCase
  fixtures :variable_hidroclimaticas

  def setup
    @controller = VariableHidroclimaticaController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = variable_hidroclimaticas(:first).id
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

    assert_not_nil assigns(:variable_hidroclimaticas)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:variable_hidroclimatica)
    assert assigns(:variable_hidroclimatica).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:variable_hidroclimatica)
  end

  def test_create
    num_variable_hidroclimaticas = VariableHidroclimatica.count

    post :create, :variable_hidroclimatica => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_variable_hidroclimaticas + 1, VariableHidroclimatica.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:variable_hidroclimatica)
    assert assigns(:variable_hidroclimatica).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      VariableHidroclimatica.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      VariableHidroclimatica.find(@first_id)
    }
  end
end
