class RepositoriesController < ApplicationController
  before_action :load_user, only: %i[index fetch]

  def index
    repos = repositories.all

    render json: repos, include: { tags: { only: :name } }
  end

  def fetch
    if fetch_repositories.execute
      render json: user.repositories, status: :created
    end
  end

  def update
    repository = Repository.find(params[:id])
    tags = repository_params[:tags]

    Services::Repository::UpdateTags.new(
      repository: repository,
      tags: tags
    ).execute

    head :no_content
  end

  private

  attr_reader :user

  def repository_params
    params.require(:repository).permit(tags: [])
  end

  def load_user
    @user = User.find_by_id(params[:user_id])
  end

  def repositories
    user.present? ? user.repositories : Repository
  end

  def fetch_repositories
    Services::Repository::Fetch.new(user)
  end
end
