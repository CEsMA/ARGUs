require File.dirname(__FILE__) + '/../test_helper'
require 'vinculotag_controller'

# Re-raise errors caught by the controller.
class VinculotagController; def rescue_action(e) raise e end; end

class VinculotagControllerTest < Test::Unit::TestCase
  fixtures :vinculotags

  def setup
    @controller = VinculotagController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = vinculotags(:first).id
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

    assert_not_nil assigns(:vinculotags)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:vinculotag)
    assert assigns(:vinculotag).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:vinculotag)
  end

  def test_create
    num_vinculotags = Vinculotag.count

    post :create, :vinculotag => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_vinculotags + 1, Vinculotag.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:vinculotag)
    assert assigns(:vinculotag).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Vinculotag.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Vinculotag.find(@first_id)
    }
  end
end
