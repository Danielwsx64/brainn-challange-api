Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create show] do
        resources :repositories, only: %i[index update] do
          collection do
            get 'search'
            post 'fetch'
          end
        end
      end
    end
  end
end
