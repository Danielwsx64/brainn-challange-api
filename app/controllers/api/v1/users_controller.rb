module Api
  module V1
    class UsersController < ApplicationController
      def show
        user = User.find_by(id: params[:id])

        if user
          render json: user, status: :ok
        else
          render json: {}, status: :not_found
        end
      end

      def create
        user = User.create(user_params)

        render json: user, status: :created
      end

      private

      def user_params
        params.require(:user).permit(:name)
      end
    end
  end
end
