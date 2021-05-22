# frozen_string_literal: true

Rails.application.routes.draw do
  scope "(:locale)", locale: /en|id/ do
    namespace :api do
      resources :my_company, only: %i[index] do
      end

      resources :companies, only: %i[update]
      resources :outlets do
        resources :products
        resources :taxonomies do
          collection do
            post :update_positions
          end
          resources :taxons
        end
      end

      resources :roles
      resources :users do
        collection do
          get :profile
          post :email_confirmation
          post :forgot_password
          post :set_new_password
        end
      end
      post '/auth/signin', to: 'user_token#create'
      post '/auth/signup', to: 'users#create'
      get '/t/*path', to: 'taxonomies#products'

      match '/*path', to: 'error#handle_root_not_found', via: :all
      resources :profile, only: %i[index] do
        collection do
          put :update_profile
          put :update_password
        end
      end
    end
  end
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
