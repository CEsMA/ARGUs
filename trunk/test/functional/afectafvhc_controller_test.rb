require File.dirname(__FILE__) + '/../test_helper'
require 'afectafvhc_controller'

# Re-raise errors caught by the controller.
class AfectafvhcController; def rescue_action(e) raise e end; end

class AfectafvhcControllerTest < Test::Unit::TestCase
  fixtures :afecta_fvhcs

  def setup
    @controller = AfectafvhcController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = afecta_fvhcs(:first).id
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

    assert_not_nil assigns(:afecta_fvhcs)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:afecta_fvhc)
    assert assigns(:afecta_fvhc).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:afecta_fvhc)
  end

  def test_create
    num_afecta_fvhcs = AfectaFvhc.count

    post :create, :afecta_fvhc => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_afecta_fvhcs + 1, AfectaFvhc.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:afecta_fvhc)
    assert assigns(:afecta_fvhc).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      AfectaFvhc.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      AfectaFvhc.find(@first_id)
    }
  end
end
