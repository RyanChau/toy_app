Rails.application.routes.draw do

  root 'static_pages#home'    # this will create two variable (or two named routes)
  # 1/ root_path -> '/' and
  # 2/ root_url  -> 'http://www.example.com/'

  # get 'static_pages/help'
  get 'help' => 'static_pages#help'     # this will create two variable (or two named routes)
  # 1/ help_path -> '/help'
  # 2/ help_url  -> 'http://www.example.com/help'

  get 'signup'  => 'users#new'
  get 'login'   => 'sessions#new'
  post 'login'   => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users do
    member do
      # /users/1/following and /users/1/followers
      get :following, :followers
    end
  end

  # define resources make up all REST URLs, but we still need to define controller and action

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:show,:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  resources :comments,          only: [:create, :destroy]
end
