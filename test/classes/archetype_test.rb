require 'test_helper'
require 'ostruct'

class ArchetypeTest < ActiveSupport::TestCase

  setup do
    @buyer = OpenStruct.new({
      "foo" => "bar",
      "data" => JSON.parse(File.read(Rails.root.join('../../test/fixtures/data.json')))
    })
    @archetype = Archetype.new(@buyer)
  end

  test "should have blank data in archetype with nil buyer data" do
    @buyer = OpenStruct.new data: nil
    @archetype = Archetype.new(@buyer)
    assert_equal Hash.new, @archetype.data
  end

  test "should get a key from data" do
    assert_equal "Male", @archetype["gender"]
  end

  test "should get a key from object" do
    assert_equal "bar", @archetype["foo"]
  end

  test "should be male?" do
    assert_equal true, @archetype.male?
  end

  test "should be female?" do
    @buyer["data"]["gender"] = 'Female'
    assert_equal true, @archetype.female?
  end

  test "should be neither male nor female" do
    @buyer["data"]["gender"] = nil
    assert_equal false, @archetype.female?
    assert_equal false, @archetype.male?
  end

  test "should be single" do
    assert_equal true, @archetype.single?
  end

  test "should have interests" do
    assert_equal [:culture, :music], @archetype.interests
  end

  test "should be interested in culture" do
    assert @archetype.interested_in?(:culture)
  end

  test "should not be interested in dog" do
    refute @archetype.interested_in?(:dog)
  end

  test "should not be interested if no interests present" do
    @buyer["data"] = {}
    refute @archetype.interested_in?(:dog)
    refute @archetype.interested_in?(:cat)
    refute @archetype.interested_in?(:x_files)
  end

  test "should have purchase_intentions" do
    assert_equal [:first_time, :investment, :needs_financing, :cash_buyer],
                 @archetype.purchase_intentions
  end

  test "should have has_purchase_intention? pied_a_terre" do
    @buyer["data"]["type_of_purchase_pied_a_terre"] = "1"
    assert @archetype.has_purchase_intention?(:pied_a_terre)
  end

  test "should have referral_sources" do
    assert_equal [:advertising, :website],
                 @archetype.referral_sources
  end

  test "should have referred_by? website" do
    @buyer["data"]["referral_source_advertising"] = "1"
    assert @archetype.referred_by?(:website)
  end

  test "should have marital_status" do
    @buyer["data"]["marital_status"] = "Single"
    assert_equal :single, @archetype.marital_status
  end

  test "should have unknown marital_status if nil" do
    @buyer["data"]["marital_status"] = nil
    assert_equal :unknown, @archetype.marital_status
  end

end
