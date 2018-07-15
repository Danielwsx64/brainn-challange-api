module Docs
  module V1
    module Repositories
      extend Dox::DSL::Syntax

      document :api do
        resource 'User Repositories' do
          endpoint '/users/:id/repositories'
          group 'User Repositories'
        end
      end

      document :index do
        action 'Get user`s repositories'
      end

      document :fetch do
        action 'Fetch starred repositories'
      end

      document :update do
        action 'Update repository tags'
      end

      document :search do
        action 'Search repositories by tag'
      end
    end
  end
end
