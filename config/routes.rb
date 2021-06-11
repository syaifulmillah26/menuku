# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|id/ do
    namespace :api do
      # backend routes
      resources :companies, only: %i[create show update] do

      end
      resources :profile, only: %i[index] do
        collection do
          put :update_profile
          put :update_password
        end
      end
      resources :outlets
      resources :orders do
        member do
          post :confirm_order
          post :finish_order
        end
      end
      resources :order_items
      resources :products do
        collection do
          post :set_product_image
        end
      end
      resources :taxonomies
      resources :taxons
      resources :tables
      resources :employees

      resources :users do
        collection do
          post :email_confirmation
          post :forgot_password
          post :set_new_password
        end
      end

      # frontend routes
      post '/auth/signin', to: 'user_token#create'
      post '/auth/signup', to: 'users#create'
      post '/auth/request', to: 'omniauth#request_provider'
      get '/*path', to: 'taxonomies#products'

      namespace :frontend do
        get '/', to: 'tables#index'
        get '/products', to: 'products#index'
        get '/products/:id', to: 'products#show'

        get '/orders/:id', to: 'orders#show'
        put '/orders/:id', to: 'orders#update'

        post '/orders/:id/confirm_order', to: 'orders#confirm_order'
        post '/order_items', to: 'order_items#create'
        put '/order_items/:id', to: 'order_items#update'
        delete '/order_items/:id', to: 'order_items#destroy'

        get '/taxonomies', to: 'taxonomies#index'
        get '/taxonomies/:id', to: 'taxonomies#show'
        get '/*path', to: 'taxonomies#products'
        match '/*path', to: 'error#handle_root_not_found', via: :all
      end
      match '/*path', to: 'error#handle_root_not_found', via: :all
    end
  end
  devise_for :users, only: %i[omniauth_callbacks]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
