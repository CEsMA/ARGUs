require File.dirname(__FILE__) + '/../test_helper'
require 'se_relaciona_vseto_controller'

# Re-raise errors caught by the controller.
class SeRelacionaVsetoController; def rescue_action(e) raise e end; end

class SeRelacionaVsetoControllerTest < Test::Unit::TestCase
  fixtures :se_relaciona_vsetos

  def setup
    @controller = SeRelacionaVsetoController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = se_relaciona_vsetos(:first).id
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

    assert_not_nil assigns(:se_relaciona_vsetos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:se_relaciona_vseto)
    assert assigns(:se_relaciona_vseto).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:se_relaciona_vseto)
  end

  def test_create
    num_se_relaciona_vsetos = SeRelacionaVseto.count

    post :create, :se_relaciona_vseto => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_se_relaciona_vsetos + 1, SeRelacionaVseto.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:se_relaciona_vseto)
    assert assigns(:se_relaciona_vseto).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      SeRelacionaVseto.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      SeRelacionaVseto.find(@first_id)
    }
  end
end
