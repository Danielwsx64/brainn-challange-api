Rails.application.routes.draw do
  get 'repositories/index'

  resources :users, only: [:show, :create] do
    resources :repositories, only: [:index] do
      collection do
        post 'fetch'
      end
    end
  end
end
