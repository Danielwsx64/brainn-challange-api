module Services
  module Repository
    class Fetch
      FailureOnFetch = Class.new(StandardError)

      def initialize(user, client = GitHub::Client)
        @user = user
        @client = client
      end

      def execute
        repositories.each(&create_repository)

        true
      rescue StandardError => exception
        raise FailureOnFetch, exception.message
      end

      private

      attr_reader :user, :client

      def create_repository
        lambda do |repository|
          user.repositories.create!(
            github_id:    repository[:id],
            name:         repository[:name],
            description:  repository[:description],
            html_url:     repository[:html_url],
            language:     repository[:language]
          )
        end
      end

      def repositories
        @repositories ||= client.user_starred user.name
      end
    end
  end
end
