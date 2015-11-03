Rails.application.routes.draw do
  
  
  get 'dashboard/index'
  root to: 'dashboard#index'
  resources :inventories do
    collection do
      match :import, action: :import, via: [:get, :post]
      get :search
      get :random
    end
  end
  
  resources :files do
    collection do
      get :download
    end
  end
  
  resources :users
  
  mount ApplicationAPI => '/api'
end
