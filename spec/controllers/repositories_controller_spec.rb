describe RepositoriesController, type: :controller do
  describe 'GET #index' do
    it 'returns all repositories as json with http success' do
      repo_one = create(:repository, name: 'awesome_api')
      repo_two = create(:repository, name: 'awesome_front')

      expected_body = [
        repo_one.as_json(include: { tags: { only: :name } }),
        repo_two.as_json(include: { tags: { only: :name } })
      ].to_json

      get :index

      expect(response.body).to eq(expected_body)
      expect(response.content_type).to eq 'application/json'
      expect(response).to have_http_status(:success)
    end

    it 'returns repositories tags' do
      repository = create(:repository_with_tags)

      expected_body = repository.as_json(
        include: { tags: { only: :name } }
      ).to_json

      get :index

      expect(response.body).to include(expected_body)
    end

    context 'when nested to user' do
      it 'returns user`s repositories as json with http success' do
        user = create(:user, name: 'Bill')

        repo_one = create(:repository, name: 'awesome_api', user: user)
        repo_two = create(:repository, name: 'awesome_front', user: user)

        _other_user_repo = create(:repository)

        expected_body = [
          repo_one.as_json(include: { tags: { only: :name } }),
          repo_two.as_json(include: { tags: { only: :name } })
        ].to_json

        get :index, params: { user_id: user.id }

        expect(response.body).to eq(expected_body)
        expect(response.content_type).to eq 'application/json'
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST #fetch' do
    it 'return fetched repositories with http status created' do
      user = create(:user, name: 'danielwsx64')

      post :fetch, params: { user_id: user.id }

      expected_github_ids = [111_328_638, 136_528_251, 136_524_424]

      response_body = JSON.parse(
        response.body
      ).map { |repo| repo['github_id'] }

      expect(response_body).to eq(expected_github_ids)
      expect(response.content_type).to eq 'application/json'
      expect(response).to have_http_status(:created)
    end
  end

  describe 'POST #update' do
    context 'change tags' do
      it 'update repository tags and return http status no_content' do
        repository = create(:repository)
        tags = %w[docker devops]

        patch :update, params: { id: repository.id, repository: { tags: tags } }

        repository_tags_names = repository.tags.map(&:name)

        expect(response).to have_http_status(:no_content)
        expect(repository_tags_names).to eq(tags)
      end
    end
  end

  describe 'GET #search' do
    context 'search by tag' do
      it 'returns tag´s repositories as json with http status success' do
        devops_tag = create(:tag, name: 'devops')
        docker_tag = create(:tag, name: 'docker')

        devops_repo = create(
          :repository,
          name: 'devops-stuff',
          tags: [devops_tag]
        )

        _docker_repo = create(
          :repository,
          name: 'devops-stuff',
          tags: [docker_tag]
        )

        expected_body = [
          devops_repo.as_json( include: { tags: { only: :name } })
        ].to_json

        get :search, params: { tag: devops_tag.name }

        expect(response.body).to eq(expected_body)
        expect(response.content_type).to eq 'application/json'
        expect(response).to have_http_status(:success)
      end

      context 'when tag not exist' do
        it 'return not status http not found' do
          tag_name = 'fake_tag'

          get :search, params: { tag: tag_name }
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
