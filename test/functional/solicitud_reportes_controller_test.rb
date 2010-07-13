require File.dirname(__FILE__) + '/../test_helper'
require 'solicitud_reportes_controller'

# Re-raise errors caught by the controller.
class SolicitudReportesController; def rescue_action(e) raise e end; end

class SolicitudReportesControllerTest < Test::Unit::TestCase
  fixtures :solicitud_reportes

  def setup
    @controller = SolicitudReportesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = solicitud_reportes(:first).id
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

    assert_not_nil assigns(:solicitud_reportes)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:solicitud_reporte)
    assert assigns(:solicitud_reporte).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:solicitud_reporte)
  end

  def test_create
    num_solicitud_reportes = SolicitudReporte.count

    post :create, :solicitud_reporte => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_solicitud_reportes + 1, SolicitudReporte.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:solicitud_reporte)
    assert assigns(:solicitud_reporte).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      SolicitudReporte.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      SolicitudReporte.find(@first_id)
    }
  end
end
