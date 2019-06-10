require 'test_helper'
require 'minitest/mock'

class Builders::BuyerBuilderTest < ActiveSupport::TestCase

  setup do
    @builder = Builders::BuyerBuilder.new(request)
  end

  test "creates a buyer from params and env" do
    assert_difference('Buyer.count') do
      unit = units(:one)

      params = {
        first_name: "Foo",
        last_name: "Bar",
        email: "foo@bar.com",
        message: "Hi foo",
        unit_ids: [unit.id]
      }.as_json

      buyer = @builder.run(params, Hashie::Mash[slug: 'foo-bar'])

      assert_equal [unit], buyer.units_of_interest.to_a
    end
  end

  test "sets units of interest on buyer" do
    unit = units(:one)

    params = {
      first_name: "Foo",
      last_name: "Bar",
      email: "foo@bar.com",
      message: "Hi foo",
      unit_ids: [unit.id]
    }.as_json

    buyer = @builder.run(params, Hashie::Mash[slug: 'foo-bar'])

    assert_equal [unit], buyer.units_of_interest.to_a
  end

  test "sets data on buyer" do
    data = { 'some' => 'json' }

    params = {
      first_name: "Foo",
      last_name: "Bar",
      email: "foo@bar.com",
      message: "Hi foo",
      unit_ids: [units(:one).id],
      data: data
    }.as_json

    buyer = @builder.run(params, Hashie::Mash[slug: 'foo-bar'])

    assert_equal data, buyer.data
  end

  test "accepts empty unit_ids" do
    params = {
      first_name: "Foo",
      last_name: "Bar",
      email: "foo@bar.com",
      message: "Hi foo",
      unit_ids: []
    }.as_json

    buyer = @builder.run(params, Hashie::Mash[slug: 'foo-bar'])

    assert_equal [], buyer.units_of_interest
  end

  test "accepts nil unit_ids" do
    params = {
      first_name: "Foo",
      last_name: "Bar",
      email: "foo@bar.com",
      message: "Hi foo"
    }.as_json

    buyer = @builder.run(params, Hashie::Mash[slug: 'foo-bar'])

    assert_equal [], buyer.units_of_interest
  end

  test "sets helped_by from sales_agent name" do
    data = { 'some' => 'json' }

    params = {
      first_name: "Foo",
      last_name: "Bar",
      email: "foo@bar.com",
      message: "Hi foo",
      unit_ids: [units(:one).id],
      sales_agent: 'Darth Vader'
    }.as_json

    buyer = @builder.run(params, Hashie::Mash[slug: 'foo-bar'])

    assert_equal 'Darth Vader', buyer.helped_by
  end

  test "works with symbol keys" do
    data = { 'some' => 'json' }

    params = {
      first_name: "Foo",
      last_name: "Bar",
      email: "foo@bar.com",
      message: "Hi foo",
      unit_ids: [units(:one).id],
      sales_agent: 'Darth Vader'
    }

    buyer = @builder.run(params, Hashie::Mash[slug: 'foo-bar'])

    assert_equal 'Darth Vader', buyer.helped_by
  end

  private

  def request
    Minitest::Mock.new
  end

end
