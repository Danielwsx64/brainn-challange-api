describe GitHub::Client do
  describe '.user_starred' do
    it 'returns user starred repositories' do
      user = 'danielwsx64'

      expected_repos_name = %w[crm-filter doctors_api doctors-front]

      repositories = described_class.user_starred(user)

      repositories_name = repositories.map { |repo| repo[:name] }

      expect(repositories_name).to eq(expected_repos_name)
    end

    context 'when user does not exists' do
      it 'raise an error' do
        user = 'some-invalid-user-to-raise-error'

        expect { described_class.user_starred(user) }.to raise_error(
          GitHub::Client::UserNotFound, 'Not Found'
        )
      end
    end
  end
end
