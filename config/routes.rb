Rails.application.routes.draw do
  resources :clients do
    resources :cards
    resources :preorders
  end
  
  post '/auth/login' => 'authentication#login'
  post '/auth/logout' => 'authentication#logout'
end