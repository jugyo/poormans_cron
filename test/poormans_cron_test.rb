require 'test_helper'

class MyController < ActionController::Base
  def index
  end
end

class PoormansCronTest < ActionController::TestCase
  def setup
    @controller = MyController.new
  end

  def test_for_filter
    mock(PoormansCron::Filter).filter(@controller) { true }
    get :index
  end

  def test_for_skip_filter
    MyController.class_eval do
      skip_before_filter PoormansCron::Filter
    end
    mock(PoormansCron::Filter).filter(@controller).times(0)
    get :index
  end
end
