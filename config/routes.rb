Rails.application.routes.draw do
  devise_for :admins
  root 'top_pages#top'
  
  devise_for :users, controllers: {
    registrations: 'users/registrations' # ユーザー情報更新
  }
  
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy' # logout
  end
  
  resources :users, only: :show

end
