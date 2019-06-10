require 'test_helper'
require 'minitest/mock'

class Builders::UniqueSlugBuilderTest < ActiveSupport::TestCase

  setup do
    @request = Minitest::Mock.new
    @env = Hashie::Mash[slug: 'foo-bar']
    @builder = Builders::UniqueSlugBuilder.new(@request)
  end

  test "should return a slug which is already unique" do
    @builder.run({}, @env)
    assert_equal 'foo-bar', @env[:slug]
  end

  test "should return a unique slug if slug in use" do
    buyers(:one).update slug: 'foo-bar'
    @builder.run({}, @env)
    assert_equal 'fbar', @env[:slug]
  end

  test "should accept a slug with only a first or last name" do
    @env.slug = "foo"
    @builder.run({}, @env)
    assert_equal 'foo', @env[:slug]
  end

  test "should return a second unique slug if slug in use" do
    buyers(:one).update slug: 'foo-bar'
    buyers(:two).update slug: 'fbar'
    @builder.run({}, @env)
    assert_equal 'foob', @env[:slug]
  end

  test "should return a third unique slug if slug in use" do
    buyers(:one).update slug: 'foo-bar'
    buyers(:two).update slug: 'fbar'
    buyers(:three).update slug: 'foob'
    @builder.run({}, @env)
    assert_equal 'foobar', @env[:slug]
  end

  test "should return a numeric slug if no permutations are available" do
    @builder.stub :available_permutations_of, [] do
      @builder.run({}, @env)
      assert_equal 'foo-bar-1', @env[:slug]
    end
  end

  test "should return a second numeric slug if no permutations are available" do
    buyers(:one).update slug: 'foo-bar-1'

    @builder.stub :available_permutations_of, [] do
      @builder.run({}, @env)
      assert_equal 'foo-bar-2', @env[:slug]
    end
  end

  test "should return a third numeric slug if no permutations are available" do
    buyers(:one).update slug: 'foo-bar-1'
    buyers(:two).update slug: 'foo-bar-2'

    @builder.stub :available_permutations_of, [] do
      @builder.run({}, @env)
      assert_equal 'foo-bar-3', @env[:slug]
    end
  end

end
