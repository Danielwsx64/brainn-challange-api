class RepositoriesController < ApplicationController
  before_action :load_user, only: :index

  def index
    repos = repositories.all

    render json: repos
  end

  private

  attr_reader :user

  def load_user
    @user = User.find_by_id(params[:user_id])
  end

  def repositories
    user.present? ? user.repositories : Repository
  end
end
