# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#home'
  post 'sign_up', to: 'users#create'
  get 'sign_up', to: 'users#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'login', to: 'sessions#new'
  get 'user/change_password', to: 'users#edit_password'
  post 'user/change_password', to: 'users#change_password'
  get 'user/update', to: 'users#edit'
  post 'user/update', to: 'users#update'
  delete 'user/delete', to: 'users#destroy'
  get 'dashboard', to: 'dashboards#index'
  get 'dashboard/add_user', to: 'dashboards#new_user'
  post 'dashboard/add_user', to: 'dashboards#create_user'
  get 'dashboard/show_user', to: 'dashboards#show_user'
  get 'dashboard/change_status/:id', to: 'dashboards#change_status'
  delete 'dashboard/delete_user/:id', to: 'dashboards#delete_user'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  resources :confirmations, only: %i[create edit new], param: :confirmation_token
  resources :passwords, only: %i[create edit new update], param: :password_reset_token
  # Defines the root path route ("/")
  # root "posts#index"
end
