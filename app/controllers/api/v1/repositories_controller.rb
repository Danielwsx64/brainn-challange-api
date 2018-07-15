module Api
  module V1
    class RepositoriesController < ApplicationController
      before_action :load_user, only: %i[index fetch search update]

      def index
        return head :not_found if user.nil?

        repositories = user.repositories.all

        render json: repositories, include: { tags: { only: :name } }
      end

      def fetch
        return head :not_found if user.nil?

        fetch_repositories.execute

        render json: user.repositories, status: :created
      rescue Services::Repository::Fetch::FailureOnFetch => exception
        render(
          json: { errors: exception.message }, status: :unprocessable_entity
        )
      end

      def update
        return head :not_found if user.nil? || repository_to_update.nil?

        Services::Repository::UpdateTags.new(
          repository: repository_to_update,
          tags: repository_params[:tags]
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

      def repository_params
        params.require(:repository).permit(tags: [])
      rescue StandardError
        raise(
          ActionController::ParameterMissing,
          'Failed on parse repository params'
        )
      end

      def sanitized_tag
        return params[:tag].downcase if params[:tag].present?
      end

      def load_user
        @user = User.find_by_id(params[:user_id])
      end

      def repository_to_update
        user.repositories.find_by_id(params[:id])
      end

      def fetch_repositories
        Services::Repository::Fetch.new(user)
      end
    end
  end
end
