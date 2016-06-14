Rails.application.routes.draw do


  resources :inventory_files
  resources :settings
  resources :parts do
    collection do
      match :import, action: :import, via: [:get, :post]
      get :search
    end
  end

  get 'dashboard/index'

  get 'dashboard/setting'

  post 'dashboard/setting'

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

  resources :users do
    collection do
      match :import, action: :import, via: [:get, :post]
      get :search
    end
  end

  mount ApplicationAPI => '/api'
end
