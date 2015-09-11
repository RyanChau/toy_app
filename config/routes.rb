Rails.application.routes.draw do

  # get 'sessions/new'

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

  resources :microposts
  resources :users
  # define resources make up all REST URLs, but we still need to define controller and action
end
