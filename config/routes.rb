# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|id/ do
    namespace :api do
      resources :my_company, only: %i[index] do
      end

      # backend routes
      resources :companies, only: %i[create update]
      resources :outlets do
        resources :products do
          collection do
            post :set_product_image
            post :update_positions
          end

          resources :variants do
            collection do
              post :update_positions
            end
          end
        end

        resources :taxonomies do
          collection do
            post :update_positions
          end
          resources :taxons
        end
      end

      resources :users do
        collection do
          post :email_confirmation
          post :forgot_password
          post :set_new_password
        end
      end

      resources :profile, only: %i[index] do
        collection do
          put :update_profile
          put :update_password
        end
      end
      resources :roles

      # frontend routes
      post '/auth/signin', to: 'user_token#create'
      post '/auth/signup', to: 'users#create'
      post '/auth/request', to: 'omniauth#request_provider'

      get '/:outlet_id', to: 'outlets#products'
      get '/:outlet_id/products/:id', to: 'outlets#product'
      get '/:outlet_id/taxonomies', to: 'taxonomies#index'
      get '/:outlet_id/taxonomies/:id', to: 'taxonomies#show'
      get '/:outlet_id/*path', to: 'taxonomies#products'
      match '/*path', to: 'error#handle_root_not_found', via: :all
    end
  end
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
