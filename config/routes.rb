Rails.application.routes.draw do
  resources :repositories, only: %i[index update] do
    get 'search', on: :collection
  end

  resources :users, only: %i[create show] do
    resources :repositories, only: %i[index] do
      collection do
        post 'fetch'
      end
    end
  end
end
