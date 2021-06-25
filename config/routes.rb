# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|id/ do
    namespace :api do
      # backend routes

      resources :profile, only: %i[index] do
        collection do
          put :update_profile
          put :update_password
        end
      end
      resources :outlets, only: %i[index update create]
      resources :orders do
        member do
          post :confirm_order
          post :finish_order
        end
      end
      resources :line_items
      resources :payment_methods, only: %i[index]
      resources :payments do
        collection do
          post :midtrans_callback
        end
      end
      resources :products do
        collection do
          post :set_image
        end
      end
      resources :taxonomies
      resources :taxons
      resources :tables do
        member do
          post :book
          post :free
        end
      end
      resources :employees
      resources :roles

      resources :users do
        collection do
          post :email_confirmation
          post :forgot_password
          post :set_new_password
        end
      end

      # frontend routes
      post '/auth/signin', to: 'user_token#create'
      # post '/auth/signup', to: 'users#create'
      # post '/auth/request', to: 'omniauth#request_provider'

      namespace :frontend do
        get '/', to: 'tables#index'
        get '/products', to: 'products#index'
        get '/products/:id', to: 'products#show'

        get '/orders/:id', to: 'orders#show'
        put '/orders/:id', to: 'orders#update'

        post '/orders/:id/confirm_order', to: 'orders#confirm_order'
        post '/line_items', to: 'line_items#create'
        put '/line_items/:id', to: 'line_items#update'
        delete '/line_items/:id', to: 'line_items#destroy'

        get '/taxonomies', to: 'taxonomies#index'
        get '/taxonomies/:id', to: 'taxonomies#show'
        get '/*path', to: 'taxonomies#products'
        match '/*path', to: 'error#handle_root_not_found', via: :all
      end
      get '/*path', to: 'taxonomies#products'
      match '/*path', to: 'error#handle_root_not_found', via: :all
    end
  end
  devise_for :users, only: %i[omniauth_callbacks]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
