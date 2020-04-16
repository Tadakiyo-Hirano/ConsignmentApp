Rails.application.routes.draw do
  root 'top_pages#top'
  
  devise_for :users
  
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end

end
