module Docs
  module V1
    module Users
      extend Dox::DSL::Syntax

      document :api do
        resource 'Users' do
          endpoint '/users'
          group 'Users'
        end
      end

      document :show do
        action 'Get an user'
      end

      document :create do
        action 'Create an user'
      end
    end
  end
end
