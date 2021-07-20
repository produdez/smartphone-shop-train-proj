Rails.application.routes.draw do
  resources :phones do
    collection do
      post :delete_selected
    end
  end

  resources :operating_systems do
    collection do
      post :delete_selected
    end
  end

  resources :brands do
    collection do
      post :delete_selected
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
