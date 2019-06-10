require 'test_helper'
require 'minitest/mock'

class Builders::BuyerUpdaterTest < ActiveSupport::TestCase

  setup do
    @builder = Builders::BuyerUpdater.new(request)
    @buyer = buyers(:one)
  end

  test "updates a buyer from params and slug" do
    @buyer.update first_name: 'Jack', slug: 'foo'

    @builder.run({ 'slug' => 'foo', 'first_name' => 'Brian' }, Hashie::Mash)

    @buyer.reload

    assert_equal 'Brian', @buyer.first_name
  end

  test "doesn't update a buyer from non-existant slug" do
    @buyer.update first_name: 'Jack', slug: 'foo'

    @builder.run({ 'slug' => 'fooby', 'first_name' => 'Brian' }, Hashie::Mash)

    @buyer.reload

    assert_equal 'Jack', @buyer.first_name
  end

  test "updates units_of_interest from unit_ids" do
    @buyer.update first_name: 'Jack', slug: 'foo'

    unit = units(:one)

    @builder.run({ 'slug' => 'foo', 'unit_ids' => [unit.id] }, Hashie::Mash)

    @buyer.reload

    assert_equal [unit], @buyer.units_of_interest(true)
  end

  test "updates helped_by from sales_agent" do
    @buyer.update helped_by: 'Jack', slug: 'foo'

    unit = units(:one)

    @builder.run({ 'slug' => 'foo', 'sales_agent' => 'Brian' }, Hashie::Mash)

    @buyer.reload

    assert_equal 'Brian', @buyer.helped_by
  end

  test "does not delete units for nil unit_id key" do
    unit = units(:one)
    @buyer.update slug: 'foo', units_of_interest: [unit]

    @builder.run({ 'slug' => 'foo', 'sales_agent' => 'Brian' }, Hashie::Mash)

    @buyer.reload

    assert_equal [unit], @buyer.units_of_interest
  end

  private

  def request
    Minitest::Mock.new
  end

end
