Rails.application.routes.draw do
  get 'relationships/create'
  get 'relationships/destroy'
  devise_for :users #順番を上にした
  
  root 'homes#top'
  get 'home/about' => 'homes#about', as: 'about'
  get 'search' => 'search#search', as: 'search'
  
  resources :users, only: [:show,:index,:edit,:update] do
    resources :relationships, only: [:create, :destroy]
    get :follows, on: :member
    get :followers, on: :member
  end
    
  resources :books do
    resources :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  
end