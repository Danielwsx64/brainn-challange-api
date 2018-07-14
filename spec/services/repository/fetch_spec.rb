describe Services::Repository::Fetch do
  describe '#execute' do
    it 'fetch repositories and return true' do
      user = create(:user, name: 'danielwsx64')

      expect(described_class.new(user).execute).to be(true)
    end

    it 'add repositories to user' do
      user = create(:user, name: 'danielwsx64')

      repository_fetch = described_class.new(user)

      expect { repository_fetch.execute }.to change(
        user.repositories,
        :count
      ).from(0).to(3)
    end

    it 'add correct repositories to user' do
      user = create(:user, name: 'danielwsx64')

      described_class.new(user).execute

      expected_github_ids = [111_328_638, 136_528_251, 136_524_424]
      fetched_repositories = user.repositories.map(&:github_id)

      expect(fetched_repositories).to eq(expected_github_ids)
    end

    context 'When can not fetch user repositories' do
      it 'raise a error' do
        user = create(:user, name: 'invalid-login-name-to-raise-error')

        expect { described_class.new(user).execute }.to raise_error(
          Services::Repository::Fetch::FailureOnFetch, 'Not Found'
        )
      end
    end
  end
end
