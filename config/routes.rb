Rails.application.routes.draw do
  resources :repositories, only: %i[index update]

  resources :users, only: %i[create show] do
    resources :repositories, only: %i[index] do
      collection do
        post 'fetch'
      end
    end
  end
end
