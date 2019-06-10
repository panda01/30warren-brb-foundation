Rails.application.routes.draw do

  scope as: 'path_based' do
    mount Foundation::API => '/api'
    mount Foundation::Documentation => '/api'
  end

  constraints subdomain: 'api' do
    mount Foundation::API => '/'
    mount Foundation::Documentation => '/'
  end

end
