require File.dirname(__FILE__) + '/../test_helper'
require 'se_mide_vuni_controller'

# Re-raise errors caught by the controller.
class SeMideVuniController; def rescue_action(e) raise e end; end

class SeMideVuniControllerTest < Test::Unit::TestCase
  fixtures :se_mide_vunis

  def setup
    @controller = SeMideVuniController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = se_mide_vunis(:first).id
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

    assert_not_nil assigns(:se_mide_vunis)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:se_mide_vuni)
    assert assigns(:se_mide_vuni).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:se_mide_vuni)
  end

  def test_create
    num_se_mide_vunis = SeMideVuni.count

    post :create, :se_mide_vuni => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_se_mide_vunis + 1, SeMideVuni.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:se_mide_vuni)
    assert assigns(:se_mide_vuni).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      SeMideVuni.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      SeMideVuni.find(@first_id)
    }
  end
end
