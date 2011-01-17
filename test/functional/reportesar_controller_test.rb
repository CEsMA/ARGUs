require File.dirname(__FILE__) + '/../test_helper'
require 'reportesar_controller'

# Re-raise errors caught by the controller.
class ReportesarController; def rescue_action(e) raise e end; end

class ReportesarControllerTest < Test::Unit::TestCase
  def setup
    @controller = ReportesarController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
