require File.dirname(__FILE__) + '/../test_helper'
require 'se_observa_controller'

# Re-raise errors caught by the controller.
class SeObservaController; def rescue_action(e) raise e end; end

class SeObservaControllerTest < Test::Unit::TestCase
  fixtures :se_observas

  def setup
    @controller = SeObservaController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = se_observas(:first).id
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

    assert_not_nil assigns(:se_observas)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:se_observa)
    assert assigns(:se_observa).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:se_observa)
  end

  def test_create
    num_se_observas = SeObserva.count

    post :create, :se_observa => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_se_observas + 1, SeObserva.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:se_observa)
    assert assigns(:se_observa).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      SeObserva.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      SeObserva.find(@first_id)
    }
  end
end
