require File.dirname(__FILE__) + '/../test_helper'
require 'composser_controller'

# Re-raise errors caught by the controller.
class ComposserController; def rescue_action(e) raise e end; end

class ComposserControllerTest < Test::Unit::TestCase
  def setup
    @controller = ComposserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
