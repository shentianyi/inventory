Rails.application.routes.draw do
  get 'file/download'
  get 'dashboard/index'
  root to: 'dashboard#index'
  resources :inventories do
    collection do
      match :import, action: :import, via: [:get, :post]
      get :search
    end
  end
  
  
  resources :users
  
end
