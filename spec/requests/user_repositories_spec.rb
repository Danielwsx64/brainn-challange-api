describe 'User`s resources management', :type => :request do
  include Docs::V1::Repositories::Api

  let(:headers) do
    { 'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/users/:id/repositories' do
    include Docs::V1::Repositories::Index

    it 'returns user`s repositories', :dox do
      user = create(:user, name: 'Bill')

      tags = [
        create(:tag),
        create(:tag)
      ]

      repo_one = create(:repository, user: user, tags: tags)
      repo_two = create(:repository, user: user, tags: tags)

      expected_body = [
        repo_one.as_json(include: { tags: { only: :name } }),
        repo_two.as_json(include: { tags: { only: :name } })
      ].to_json

      get api_v1_user_repositories_path(user), headers: headers

      expect(response.body).to eq(expected_body)
      expect(response.content_type).to eq 'application/json'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /api/v1/users/:id/repositories/fetch' do
    include Docs::V1::Repositories::Fetch

    it 'fetch starred repositories' do
      user = create(:user, name: 'danielwsx64')

      post fetch_api_v1_user_repositories_path(user), headers: headers

      expected_github_ids = [111_328_638, 136_528_251, 136_524_424]

      response_body = JSON.parse(
        response.body
      ).map { |repo| repo['github_id'] }

      expect(response_body).to eq(expected_github_ids)
      expect(response.content_type).to eq 'application/json'
      expect(response).to have_http_status(:created)
    end
  end

  describe 'PATCH /api/v1/users/:user_id/repositories/:id' do
    include Docs::V1::Repositories::Update

    it 'updates repository tags', :dox do
      repository = create(:repository)
      tags = %w[docker devops]

      patch(
        api_v1_user_repository_path(repository.user, repository),
        params: { repository: { tags: tags } },
        headers: headers
      )

      repository_tags_names = repository.tags.map(&:name)

      expect(response).to have_http_status(:no_content)
      expect(repository_tags_names).to eq(tags)
    end
  end

  describe 'GET /api/v1/users/:user_id/repositories/search' do
    include Docs::V1::Repositories::Search

    it 'search repositories by tag', :dox do
      devops_tag = create(:tag, name: 'devops')

      devops_repo = create(
        :repository,
        name: 'devops-stuff',
        tags: [devops_tag]
      )

      expected_body = [
        devops_repo.as_json(include: { tags: { only: :name } })
      ].to_json

      get(
        search_api_v1_user_repositories_path(devops_repo.user),
        params: { tag: devops_tag.name },
        headers: headers
      )

      expect(response.body).to eq(expected_body)
      expect(response.content_type).to eq 'application/json'
      expect(response).to have_http_status(:success)
    end
  end
end
