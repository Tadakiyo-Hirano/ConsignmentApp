Rails.application.routes.draw do
  root 'top_pages#top'
  
  devise_for :users
end
