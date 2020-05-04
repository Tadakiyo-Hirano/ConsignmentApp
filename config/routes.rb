Rails.application.routes.draw do
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
  
  resources :admins, only: :show do
    collection do
      get 'users_index' # 担当者一覧
    end
  end
  
  resources :users, only: %i(show update)

end
