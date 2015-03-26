require File.dirname(__FILE__) + '/../test_helper'
require 'reportepentahos_controller'

# Re-raise errors caught by the controller.
class ReportepentahosController; def rescue_action(e) raise e end; end

class ReportepentahosControllerTest < Test::Unit::TestCase
  fixtures :reportepentahos

  def setup
    @controller = ReportepentahosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = reportepentahos(:first).id
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

    assert_not_nil assigns(:reportepentahos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:reportepentaho)
    assert assigns(:reportepentaho).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:reportepentaho)
  end

  def test_create
    num_reportepentahos = Reportepentaho.count

    post :create, :reportepentaho => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_reportepentahos + 1, Reportepentaho.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:reportepentaho)
    assert assigns(:reportepentaho).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Reportepentaho.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Reportepentaho.find(@first_id)
    }
  end
end
