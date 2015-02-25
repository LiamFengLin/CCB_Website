Ccb::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { :sessions => "json_sessions" }
  root to: 'home#index'
  
  resources :resource_files, param: :file_name, :constraints => { :file_name => /.+\..+/ }, only: [:index, :show]
  get "admin/batch_update" => "resource_files#batch_update"

  resources :announcements, only: [:index, :create]
end
