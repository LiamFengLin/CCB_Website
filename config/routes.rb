Ccb::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { :registrations => "registrations" }
  root to: 'home#index'

  resources :users, only: [:index, :show]
  devise_scope :user do
    post 'sign_in' => 'sessions#create'
    delete 'sign_out' => 'sessions#destroy'
  end
  
  resources :resource_files, param: :file_name, :constraints => { :file_name => /.+\..+/ }, only: [:index, :show] do
    get "fetch_thumbnail" => "resource_files#fetch_thumbnail"
  end
  
  get "admin/batch_update" => "resource_files#batch_update"

  resources :announcements, only: [:index, :create]
end
