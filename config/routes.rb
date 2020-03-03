Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :api, format: 'json' do
    resources :books, only: %i[index show], param: :title
    get :search, to: 'books#search'
    get :ranking, to: 'books#ranking'
    resources :authors, only: %i[index show], param: :name
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
