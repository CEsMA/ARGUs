require File.dirname(__FILE__) + '/../test_helper'
require 'periodo_operacion_controller'

# Re-raise errors caught by the controller.
class PeriodoOperacionController; def rescue_action(e) raise e end; end

class PeriodoOperacionControllerTest < Test::Unit::TestCase
  fixtures :periodo_operacions

  def setup
    @controller = PeriodoOperacionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = periodo_operacions(:first).id
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

    assert_not_nil assigns(:periodo_operacions)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:periodo_operacion)
    assert assigns(:periodo_operacion).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:periodo_operacion)
  end

  def test_create
    num_periodo_operacions = PeriodoOperacion.count

    post :create, :periodo_operacion => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_periodo_operacions + 1, PeriodoOperacion.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:periodo_operacion)
    assert assigns(:periodo_operacion).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      PeriodoOperacion.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      PeriodoOperacion.find(@first_id)
    }
  end
end
