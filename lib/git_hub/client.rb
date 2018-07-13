module GitHub
  class Client
    UserNotFound = Class.new(StandardError)

    def self.user_starred(user)
      response = Faraday.get "#{GITHUB_CONFIG['url']}/users/#{user}/starred"

      return JSON.parse(
        response.body,
        symbolize_names: true
      ) if response.success?

      raise(
        UserNotFound,  response.reason_phrase
      ) if response.status.eql?(404)
    end
  end
end
