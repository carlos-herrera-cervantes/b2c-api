Rails.application.routes.draw do
  resources :clients do
    resources :cards
    resources :preorders
  end
end