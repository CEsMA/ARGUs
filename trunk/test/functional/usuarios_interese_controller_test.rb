require File.dirname(__FILE__) + '/../test_helper'
require 'usuarios_interese_controller'

# Re-raise errors caught by the controller.
class UsuariosIntereseController; def rescue_action(e) raise e end; end

class UsuariosIntereseControllerTest < Test::Unit::TestCase
  fixtures :usuarios_intereses

  def setup
    @controller = UsuariosIntereseController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = usuarios_intereses(:first).id
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

    assert_not_nil assigns(:usuarios_intereses)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:usuarios_interese)
    assert assigns(:usuarios_interese).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:usuarios_interese)
  end

  def test_create
    num_usuarios_intereses = UsuariosInterese.count

    post :create, :usuarios_interese => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_usuarios_intereses + 1, UsuariosInterese.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:usuarios_interese)
    assert assigns(:usuarios_interese).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      UsuariosInterese.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      UsuariosInterese.find(@first_id)
    }
  end
end
