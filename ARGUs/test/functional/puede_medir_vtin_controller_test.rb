require File.dirname(__FILE__) + '/../test_helper'
require 'puede_medir_vtin_controller'

# Re-raise errors caught by the controller.
class PuedeMedirVtinController; def rescue_action(e) raise e end; end

class PuedeMedirVtinControllerTest < Test::Unit::TestCase
  fixtures :puede_medir_vtins

  def setup
    @controller = PuedeMedirVtinController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = puede_medir_vtins(:first).id
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

    assert_not_nil assigns(:puede_medir_vtins)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:puede_medir_vtin)
    assert assigns(:puede_medir_vtin).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:puede_medir_vtin)
  end

  def test_create
    num_puede_medir_vtins = PuedeMedirVtin.count

    post :create, :puede_medir_vtin => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_puede_medir_vtins + 1, PuedeMedirVtin.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:puede_medir_vtin)
    assert assigns(:puede_medir_vtin).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      PuedeMedirVtin.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      PuedeMedirVtin.find(@first_id)
    }
  end
end
