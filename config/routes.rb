# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins, path: '/', path_names: {
    sign_in: 'login',
    sign_out: 'logout'
  }, controllers: { sessions: 'sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post ':store_id/webhook', to: 'webhooks#webhook'

  root to: 'home#index'

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :orders, only: [:index] do
      get 'data', on: :collection,
                  action: :table_data, defaults: { format: 'json' }
    end
    resources :products, only: [:index]
  end
end
