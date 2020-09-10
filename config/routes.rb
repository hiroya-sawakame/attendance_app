Rails.application.routes.draw do
  get 'bases/new'

  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      get 'edit_basic_info'
      get 'overtime', to: 'attendances#overtime'
      patch 'create_overtime', to: 'attendances#create_overtime'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end
    resources :attendances, only: :update
  end

  resources :bases, only: [:new, :update, :create, :destroy]
end