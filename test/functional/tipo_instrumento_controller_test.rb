require File.dirname(__FILE__) + '/../test_helper'
require 'tipo_instrumento_controller'

# Re-raise errors caught by the controller.
class TipoInstrumentoController; def rescue_action(e) raise e end; end

class TipoInstrumentoControllerTest < Test::Unit::TestCase
  fixtures :tipo_instrumentos

  def setup
    @controller = TipoInstrumentoController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = tipo_instrumentos(:first).id
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

    assert_not_nil assigns(:tipo_instrumentos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:tipo_instrumento)
    assert assigns(:tipo_instrumento).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:tipo_instrumento)
  end

  def test_create
    num_tipo_instrumentos = TipoInstrumento.count

    post :create, :tipo_instrumento => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_tipo_instrumentos + 1, TipoInstrumento.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:tipo_instrumento)
    assert assigns(:tipo_instrumento).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      TipoInstrumento.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      TipoInstrumento.find(@first_id)
    }
  end
end
