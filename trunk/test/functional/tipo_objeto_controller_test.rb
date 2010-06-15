require File.dirname(__FILE__) + '/../test_helper'
require 'tipo_objeto_controller'

# Re-raise errors caught by the controller.
class TipoObjetoController; def rescue_action(e) raise e end; end

class TipoObjetoControllerTest < Test::Unit::TestCase
  fixtures :tipo_objetos

  def setup
    @controller = TipoObjetoController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = tipo_objetos(:first).id
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

    assert_not_nil assigns(:tipo_objetos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:tipo_objeto)
    assert assigns(:tipo_objeto).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:tipo_objeto)
  end

  def test_create
    num_tipo_objetos = TipoObjeto.count

    post :create, :tipo_objeto => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_tipo_objetos + 1, TipoObjeto.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:tipo_objeto)
    assert assigns(:tipo_objeto).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      TipoObjeto.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      TipoObjeto.find(@first_id)
    }
  end
end
