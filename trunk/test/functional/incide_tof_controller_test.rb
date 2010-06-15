require File.dirname(__FILE__) + '/../test_helper'
require 'incide_tof_controller'

# Re-raise errors caught by the controller.
class IncideTofController; def rescue_action(e) raise e end; end

class IncideTofControllerTest < Test::Unit::TestCase
  fixtures :incide_tofs

  def setup
    @controller = IncideTofController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = incide_tofs(:first).id
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

    assert_not_nil assigns(:incide_tofs)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:incide_tof)
    assert assigns(:incide_tof).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:incide_tof)
  end

  def test_create
    num_incide_tofs = IncideTof.count

    post :create, :incide_tof => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_incide_tofs + 1, IncideTof.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:incide_tof)
    assert assigns(:incide_tof).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      IncideTof.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      IncideTof.find(@first_id)
    }
  end
end
