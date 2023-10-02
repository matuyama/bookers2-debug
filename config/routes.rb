Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "homes#top"
  get "home/about"=>"homes#about"
  devise_for :users
  get "search" => "searches#search"
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'following_users' => 'relationships#following_users', as: 'followings'
    get 'follower_users' => 'relationships#follower_users', as: 'followers'
    get "search" => "users#search"
  end
  resources :groups, only: [:new, :index, :show, :create, :edit, :update] do
    resource :group_user, only: [:create, :destroy]
    get "new/mail" => "groups#new_mail"
    get "send/mail" => "groups#send_mail"
  end

  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show]
  get 'tagsearches/search', to: 'tagsearches#search'

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
