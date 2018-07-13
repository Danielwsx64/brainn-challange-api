module GitHub
  class Client
    UserNotFound = Class.new(StandardError)

    def self.user_starred(user)
      request = Faraday.get "#{GITHUB_CONFIG['url']}/users/#{user}/starred"

      return JSON.parse(request.body, symbolize_names: true) if request.success?

      raise(UserNotFound, request.reason_phrase) if request.status.eql?(404)
    end
  end
end
