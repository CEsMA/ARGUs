require File.dirname(__FILE__) + '/../test_helper'
require 'variable_socioeconomica_controller'

# Re-raise errors caught by the controller.
class VariableSocioeconomicaController; def rescue_action(e) raise e end; end

class VariableSocioeconomicaControllerTest < Test::Unit::TestCase
  fixtures :variable_socioeconomicas

  def setup
    @controller = VariableSocioeconomicaController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = variable_socioeconomicas(:first).id
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

    assert_not_nil assigns(:variable_socioeconomicas)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:variable_socioeconomica)
    assert assigns(:variable_socioeconomica).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:variable_socioeconomica)
  end

  def test_create
    num_variable_socioeconomicas = VariableSocioeconomica.count

    post :create, :variable_socioeconomica => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_variable_socioeconomicas + 1, VariableSocioeconomica.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:variable_socioeconomica)
    assert assigns(:variable_socioeconomica).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      VariableSocioeconomica.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      VariableSocioeconomica.find(@first_id)
    }
  end
end
