Rails.application.routes.draw do
  # get 'consignments/new'
  root 'top_pages#top'
  
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
    passwords: 'admins/passwords',
    registrations: 'admins/registrations'
  }
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations' # ユーザー情報更新
  }
  
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy' # logout
  end
  
  resources :admins, only: %i(show index)
  
  resources :users, only: %i(index show update destroy) do
    resources :consignments do
      collection do
        get 'by_customer', to: 'consignments#by_customer'
        get 'documents'
        get 'by_product', to: 'consignments#by_product'
      end
      resources :stocks
    end
    member do
      patch 'password_update' # パスワード更新
      get 'end_tasks'
    end
  end
  
  resources :products do
    collection do
      post 'import'
    end
  end
  
  resources :customers do
    collection do
      post 'import'
    end
  end
  
  post 'callback', to: 'linebot#callback'

end
