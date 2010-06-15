require File.dirname(__FILE__) + '/../test_helper'
require 'consultatag_controller'

# Re-raise errors caught by the controller.
class ConsultatagController; def rescue_action(e) raise e end; end

class ConsultatagControllerTest < Test::Unit::TestCase
  fixtures :consultatags

  def setup
    @controller = ConsultatagController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = consultatags(:first).id
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

    assert_not_nil assigns(:consultatags)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:consultatag)
    assert assigns(:consultatag).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:consultatag)
  end

  def test_create
    num_consultatags = Consultatag.count

    post :create, :consultatag => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_consultatags + 1, Consultatag.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:consultatag)
    assert assigns(:consultatag).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Consultatag.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Consultatag.find(@first_id)
    }
  end
end
