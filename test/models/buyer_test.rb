require 'test_helper'

class BuyerTest < ActiveSupport::TestCase

  test "must be helped_by" do
    buyer = buyers(:one)
    buyer.update_attribute :helped_by, 'MJ'
    assert_equal 'MJ', buyer.helped_by
  end

  test "must have an archetype" do
    buyer = buyers(:one)
    assert_kind_of Archetype, buyer.archetype
  end

end
