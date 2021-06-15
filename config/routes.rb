Rails.application.routes.draw do
  devise_for :users
  # For  on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  resources :promotions, only: %i[index show new create edit update destroy delete search teste] do
    post 'generate_coupons', on: :member
    get 'search', on: :collection
    post 'approved', on: :member
  end
  resources :product_categories, only: %i[index show new create edit update destroy delete]
  resources :coupons, only: [] do
    post 'inactivate', on: :member
    post 'activate', on: :member
  end
  resources :testes, only: %i[index show new create edit update destroy delete search teste]

  namespace :api do
    namespace :v1 do
      resources :coupons, param: :code, only: %i[show] do
        post '/burn', on: :member, to: 'coupons#burn'
      end
    end
  end
end
