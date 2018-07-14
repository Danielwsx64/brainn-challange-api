class RepositoriesController < ApplicationController
  before_action :load_user, only: %i[index fetch search]

  def index
    return head :not_found unless user.present?

    repositories = user.repositories.all

    render json: repositories, include: { tags: { only: :name } }
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

  def search
    return head :not_found unless user.present?

    repositories = user
      .repositories
      .joins(:tags)
      .where(tags: { name: sanitized_tag })

    render json: repositories, include: { tags: { only: :name } }
  end

  private

  attr_reader :user

  def sanitized_tag
    return params[:tag].downcase if params[:tag].present?
  end

  def repository_params
    params.require(:repository).permit(tags: [])
  end

  def load_user
    @user = User.find_by_id(params[:user_id])
  end

  def fetch_repositories
    Services::Repository::Fetch.new(user)
  end
end
