module Services
  module Repository
    class Fetch
      FailureOnFetch = Class.new(StandardError)

      def initialize(user, client = GitHub::Client)
        @user = user
        @client = client
      end

      def execute
        remove_unwanted_repositories

        repositories.each(&create_or_update)

        true
      rescue StandardError => exception
        raise FailureOnFetch, exception.message
      end

      private

      attr_reader :user, :client

      def create_or_update
        lambda do |repository_data|
          repository = ::Repository
            .find_by(github_id: repository_data[:id])

          if repository.present?
            update_repository(repository, repository_data)
          else
            create_repository(repository_data)
          end
        end
      end

      def update_repository(repository, repository_data)
        repository.update_attributes!(
          name:         repository_data[:name],
          description:  repository_data[:description],
          html_url:     repository_data[:html_url],
          language:     repository_data[:language]
        )
      end

      def create_repository(repository)
        user.repositories.create!(
          github_id:    repository[:id],
          name:         repository[:name],
          description:  repository[:description],
          html_url:     repository[:html_url],
          language:     repository[:language]
        )
      end

      def repositories
        @repositories ||= client.user_starred user.name
      end

      def wanted_repositories_github_id
        repositories.map{ |r| r[:id] }
      end

      def unwanted_repositories
        user.repositories.where.not(github_id: wanted_repositories_github_id)
      end

      def remove_unwanted_repositories
        unwanted_repositories.each(&:delete)
      end
    end
  end
end
