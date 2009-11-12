require 'test_helper'

class FilterTest < ActiveSupport::TestCase
  test 'should call PoormansCron.perform' do
    stub(Thread).start { |block| block.call }
    PoormansCron::Filter.filter(nil)
  end
end
