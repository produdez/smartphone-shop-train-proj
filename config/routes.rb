Rails.application.routes.draw do
  root to: 'phones#index'

  devise_for :users, skip: %i[registrations passwords], controllers: { sessions: 'users/sessions' }

  resources :phones do
    collection do
      post :delete_selected
    end
  end

  resources :users, only: [:show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
