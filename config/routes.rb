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
  
  resources :admins, only: :show
  
  resources :users, only: %i(index show update) do
    resources :consignments do
      collection do
        get 'by_customer', to: 'consignments#by_customer'
        get 'by_customer_pdfs', to: 'consignments#by_customer_pdfs'
        get 'by_product', to: 'consignments#by_product'
      end
      resources :stocks
    end
    member do
      patch 'password_update' # パスワード更新
      get 'end_tasks'
    end
  end
  
  resources :products
  resources :customers
  resources :apis, only: :index

end
