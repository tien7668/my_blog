Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  namespace :admin do
    resources :users
    resources :posts
  end
  resources :posts
  post 'comments/save_comment'
  put 'comments/save_comment'
end
