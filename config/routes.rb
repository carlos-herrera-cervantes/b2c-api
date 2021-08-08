Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  resources :clients do
    resources :cards
    resources :preorders
  end

  resources :api_key
  
  post '/auth/login' => 'authentication#login'
  post '/auth/logout' => 'authentication#logout'
end