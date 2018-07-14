describe 'User resources management', :type => :request do
  it 'creates a user' do
    user_params = { name: 'Bill' }

    post api_v1_users_path, params: { user: user_params }

    parsed_body = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_body).to include user_params
    expect(response.content_type).to eq 'application/json'
    expect(response).to have_http_status(:created)
  end

  it 'shows a user' do
    user = create(:user)
    expected_response = user.to_json

    get api_v1_user_path(user)

    expect(response.body).to eq(expected_response)
    expect(response.content_type).to eq 'application/json'
    expect(response).to have_http_status(:success)
  end

  it 'shows user repositories' do
    user = create(:user, name: 'Bill')

    repo_one = create(:repository, name: 'awesome_api', user: user)
    repo_two = create(:repository, name: 'awesome_front', user: user)

    expected_body = [
      repo_one.as_json(include: { tags: { only: :name } }),
      repo_two.as_json(include: { tags: { only: :name } })
    ].to_json

    get api_v1_user_repositories_path(user)

    expect(response.body).to eq(expected_body)
    expect(response.content_type).to eq 'application/json'
    expect(response).to have_http_status(:success)
  end

  it 'fetch user starred repositories from github' do
    user = create(:user, name: 'danielwsx64')

    post fetch_api_v1_user_repositories_path(user)

    expected_github_ids = [111_328_638, 136_528_251, 136_524_424]

    response_body = JSON.parse(
      response.body
    ).map { |repo| repo['github_id'] }

    expect(response_body).to eq(expected_github_ids)
    expect(response.content_type).to eq 'application/json'
    expect(response).to have_http_status(:created)
  end

  it 'update user repository tags' do
    repository = create(:repository)
    tags = %w[docker devops]

    patch(
      api_v1_user_repository_path(repository.user, repository),
      params: { repository: { tags: tags } }
    )

    repository_tags_names = repository.tags.map(&:name)

    expect(response).to have_http_status(:no_content)
    expect(repository_tags_names).to eq(tags)
  end

  it 'search user repositories by tag' do
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
      params: { tag: devops_tag.name }
    )

    expect(response.body).to eq(expected_body)
    expect(response.content_type).to eq 'application/json'
    expect(response).to have_http_status(:success)
  end
end
