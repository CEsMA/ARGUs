require File.dirname(__FILE__) + '/../test_helper'
require 'se_asocia_vhcto_controller'

# Re-raise errors caught by the controller.
class SeAsociaVhctoController; def rescue_action(e) raise e end; end

class SeAsociaVhctoControllerTest < Test::Unit::TestCase
  fixtures :se_asocia_vhctos

  def setup
    @controller = SeAsociaVhctoController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = se_asocia_vhctos(:first).id
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

    assert_not_nil assigns(:se_asocia_vhctos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:se_asocia_vhcto)
    assert assigns(:se_asocia_vhcto).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:se_asocia_vhcto)
  end

  def test_create
    num_se_asocia_vhctos = SeAsociaVhcto.count

    post :create, :se_asocia_vhcto => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_se_asocia_vhctos + 1, SeAsociaVhcto.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:se_asocia_vhcto)
    assert assigns(:se_asocia_vhcto).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      SeAsociaVhcto.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      SeAsociaVhcto.find(@first_id)
    }
  end
end
