# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'phones#index'

  devise_for :users, skip: %i[registrations passwords], controllers: { sessions: 'users/sessions' }
  resources :users, only: %i[show index] do
    collection do
      get :new_manager
      post :create_manager
      get :new_employee
      post :create_employee
    end
  end

  resources :phones do
    collection do
      post :delete_selected
      post :set_unavailable_selected
    end
  end

  resources :operating_systems
  resources :brands
  resources :models

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
