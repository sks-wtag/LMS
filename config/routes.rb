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
  #all of dashboard routes
  get 'dashboard', to: 'dashboards#index'
  get 'dashboard/add_user', to: 'dashboards#new_user'
  post 'dashboard/add_user', to: 'dashboards#create_user'
  get 'dashboard/show_user', to: 'dashboards#show_user'
  get 'dashboard/change_status/:id', to: 'dashboards#change_status'
  delete 'dashboard/delete_user/:id', to: 'dashboards#delete_user'
  #all of course related routes
  get 'dashboard/add_course', to: 'courses#new_course'
  post 'dashboard/add_course', to: 'courses#create_course'
  get 'dashboard/show_course', to: 'courses#show_course'
  get 'dashboard/edit_course/:id', to: 'courses#edit_course'
  patch 'dashboard/edit_course/:id', to: 'courses#save_course'
  delete 'dashboard/delete_course/:id', to: 'courses#destroy_course'
  get 'dashboard/show_a_course/:id', to: 'courses#show_single_course'
  #all of lesson related routes
  post 'dashboard/add_lesson/:course_id', to: 'lessons#create_lesson'
  delete 'dashboard/delete_lesson/:lesson_id', to: 'lessons#destroy_lesson'
  get 'dashboard/edit_lesson/:lesson_id', to: 'lessons#edit_lesson'
  patch 'dashboard/edit_lesson/:lesson_id', to: 'lessons#save_lesson'
  #all of content related routes
  post 'dashboard/save_content/:lesson_id', to: 'contents#create_content'
  delete 'dashboard/delete_content/:content_id', to: 'contents#destroy_content'
  #all of enrollment related routes
  get 'dashboard/enroll_course/:course_id', to: 'enrollments#index'
  post 'dashboard/enroll_course/:course_id', to: 'enrollments#enroll'
  delete 'dashboard/dis_enroll_course/:course_id', to: 'enrollments#dis_enroll'
  post 'dashboard/complete_lesson/:lesson_id', to: 'enrollments#complete_lesson'
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  get 'up' => 'rails/health#show', as: :rails_health_check
  resources :confirmations, only: %i[create edit new], param: :confirmation_token
  resources :passwords, only: %i[create edit new update], param: :password_reset_token
  match "*path", to: "application#not_found", via: :all, constraints: ->(req) { !req.path.start_with?('/rails/active_storage') }
end
