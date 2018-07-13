class UsersController < ApplicationController
  def show
    user = User.find_by(id: params[:id])

    if user
      render json: user, status: :ok
    else
      render json: {}, status: :not_found
    end
  end
end
