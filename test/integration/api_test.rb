require "test_helper"

class APITest < ActionDispatch::IntegrationTest

  test "should create a buyer with API" do
    assert_difference('Buyer.count') do
      post '/api/v1/interest', valid_params_with_unit(units(:one))
    end
  end

  test "should create a buyer with subdomain API" do
    assert_difference('Buyer.count') do
      host! 'api.example.com'
      post '/v1/interest', valid_params_with_unit(units(:one))
    end
  end

  test "should create a buyer with www API" do
    assert_difference('Buyer.count') do
      host! 'www.example.com'
      post '/api/v1/interest', valid_params_with_unit(units(:one))
    end

    buyer = Buyer.last
    assert_equal 'foo-bar', buyer.slug
  end

  test "should update a buyer with API" do
    buyer = buyers(:one)
    buyer.update slug: 'foobar'

    params = valid_params_with_unit(units(:one)).merge "slug" => 'foobar'

    patch '/api/v1/interest', params

    buyer.reload

    assert_equal params['first_name'], buyer.first_name
  end

  test "should update a buyer with subdomain API" do
    host! 'api.example.com'

    buyer = buyers(:one)
    buyer.update slug: 'foobar'

    params = valid_params_with_unit(units(:one)).merge "slug" => 'foobar'

    patch '/api/v1/interest', params

    buyer.reload

    assert_equal params['first_name'], buyer.first_name
  end

  test "should give a url based on buyer slug" do
    2.times do
      post '/api/v1/interest', valid_params_with_unit(units(:one)), host: 'localhost'
      json = JSON.parse(response.body)
      assert_equal "http://#{json['slug']}.localhost", json['url']
    end
  end

  test "should give a url based on buyer slug with subdomain API" do
    host! 'api.example.com'

    2.times do
      post '/api/v1/interest', valid_params_with_unit(units(:one)), host: 'localhost'
      json = JSON.parse(response.body)
      assert_equal "http://#{json['slug']}.localhost", json['url']
    end
  end

  protected

  def valid_params_with_unit unit
    {
      "first_name" => 'foo',
      "last_name" => 'bar',
      "email" => 'foo@bar.com',
      "unit_ids" => [unit.id]
    }
  end
end
