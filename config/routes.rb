Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :groups

  resources :product_changes, only: [:index]

  root 'groups#index'
end
