Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  mount API::Base => '/api'

  mount GrapeSwaggerRails::Engine => '/api/docs'
  mount Ckeditor::Engine => '/ckeditor'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  namespace :admin do
    root to: redirect(path: '/admin/posts')
    resources :users
    resources :categories
    resources :posts
    post :ajax_delete_multiple_post, to: 'posts#ajax_delete_multiple_post'
  end
  resources :posts
  post :ajax_get_posts, to: 'home#ajax_get_posts' 
  post 'comments/save_comment'
  put 'comments/save_comment'

  get "about_us", to: "home#about_us"
  get "service", to: "home#service"
end
