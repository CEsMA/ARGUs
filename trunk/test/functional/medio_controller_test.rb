require File.dirname(__FILE__) + '/../test_helper'
require 'medio_controller'

# Re-raise errors caught by the controller.
class MedioController; def rescue_action(e) raise e end; end

class MedioControllerTest < Test::Unit::TestCase
  fixtures :medios

  def setup
    @controller = MedioController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = medios(:first).id
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

    assert_not_nil assigns(:medios)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:medio)
    assert assigns(:medio).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:medio)
  end

  def test_create
    num_medios = Medio.count

    post :create, :medio => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_medios + 1, Medio.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:medio)
    assert assigns(:medio).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Medio.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Medio.find(@first_id)
    }
  end
end
