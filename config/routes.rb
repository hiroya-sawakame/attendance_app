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
      get 'changed_log'
      # js ファイルが絡むルーティングは to:〜 を設定
      get 'overtime', to: 'attendances#overtime'
      patch 'create_overtime', to: 'attendances#create_overtime'
      get 'approval_overtime', to: 'attendances#approval_overtime'
      patch 'approval_overtime', to: 'attendances#approval_overtime_done'
      get 'approval_changed_working_time', to: 'attendances#approval_changed_working_time'
      patch 'approval_changed_working_time', to: 'attendances#approval_changed_working_time_done'
      patch 'update_basic_info'
      get 'export_month'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end
    resources :attendances, only: :update
  end

  resources :bases, only: [:new, :update, :create, :destroy]
end