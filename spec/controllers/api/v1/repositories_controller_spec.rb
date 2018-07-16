describe Api::V1::RepositoriesController, type: :controller do
  describe 'GET #index' do
    it 'returns user`s repositories as json with http ok' do
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
      expect(response).to have_http_status(:ok)
    end

    it 'returns repositories tags' do
      repository = create(:repository_with_tags)

      expected_body = repository.as_json(
        include: { tags: { only: :name } }
      ).to_json

      get :index, params: { user_id: repository.user.id }

      expect(response.body).to include(expected_body)
    end

    context 'when not found user' do
      it 'returns http status not found' do
        get :index, params: { user_id: 0 }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #fetch' do
    it 'fetch user repositories' do
      user = create(:user, name: 'danielwsx64')

      expect do
        post :fetch, params: { user_id: user.id }
      end.to change(user.repositories, :count).from(0).to(3)
    end

    it 'returns fetched repositories with http status created' do
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

    context 'when can not fetch user repositories' do
      it 'returns http status unprocessable_entity' do
        user = create(:user, name: 'some-invalid-user-to-raise-error')

        post :fetch, params: { user_id: user.id }

        expect(response.body).to include 'errors'
        expect(response.content_type).to eq 'application/json'
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user not exists' do
      it 'returns http status not_found' do
        post :fetch, params: { user_id: 0 }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #update' do
    context 'change tags' do
      it 'update repository tags' do
        repository = create(:repository, tags: [])
        tags = %w[docker devops]

        expect do
          patch :update, params: {
            user_id: repository.user.id,
            id: repository.id,
            repository: { tags: tags }
          }
        end.to change(repository.tags, :count).from(0).to(2)
      end

      it 'returns http status no_content' do
        repository = create(:repository)
        tags = %w[docker devops]

        patch :update, params: {
          user_id: repository.user.id,
          id: repository.id,
          repository: { tags: tags }
        }

        expect(response).to have_http_status(:no_content)
      end

      it 'remove old tags' do
        old_tag =  create(:tag, name: 'some_old')
        repository = create(:repository, tags: [old_tag])
        tags = %w[docker devops]

        patch :update, params: {
          user_id: repository.user.id,
          id: repository.id,
          repository: { tags: tags }
        }

        repository.reload

        repository_tags_names = repository.tags.map(&:name)
        expect(repository_tags_names).to eq(tags)
      end

      context 'when invalid params' do
        it 'return http status bad_request' do
          repository = create(:repository)
          repository_params = 'invalid_params'

          patch :update, params: {
            user_id: repository.user.id,
            id: repository.id,
            repository: repository_params
          }

          expect(response.body).to include 'bad request'
          expect(response.content_type).to eq 'application/json'
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when user not exists' do
        it 'returns http status not_found' do
          repository = create(:repository)

          patch :update, params: {
            user_id: 0,
            id: repository.id,
            repository: { tags: [] }
          }

          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when repository not exists' do
        it 'returns http status not_found' do
          user = create(:user)

          patch :update, params: {
            user_id: user.id,
            id: 0,
            repository: { tags: [] }
          }

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'GET #search' do
    context 'search by tag' do
      it 'returns tag´s repositories as json with http status ok' do
        user = create(:user, name: 'Bill')

        devops_tag = create(:tag, name: 'devops')
        docker_tag = create(:tag, name: 'docker')

        devops_repo = create(
          :repository,
          name: 'devops-stuff',
          user: user,
          tags: [devops_tag]
        )

        _docker_repo = create(
          :repository,
          name: 'docker-stuff',
          user: user,
          tags: [docker_tag]
        )

        expected_body = [
          devops_repo.as_json(include: { tags: { only: :name } })
        ].to_json

        get :search, params: { user_id: user.id, tag: devops_tag.name }

        expect(response.body).to eq(expected_body)
        expect(response.content_type).to eq 'application/json'
        expect(response).to have_http_status(:ok)
      end

      it 'returns just user repositories' do
        user = create(:user, name: 'Bill')

        docker_tag = create(:tag, name: 'docker')

        user_repo = create(
          :repository,
          name: 'docker-stuff',
          user: user,
          tags: [docker_tag]
        )

        _other_repo = create(
          :repository,
          name: 'docker-stuff',
          tags: [docker_tag]
        )

        expected_body = [
          user_repo.as_json(include: { tags: { only: :name } })
        ].to_json

        get :search, params: { user_id: user.id, tag: docker_tag.name }

        expect(response.body).to eq(expected_body)
      end

      context 'when has no repos with tag' do
        it 'returns empty with http status ok' do
          user = create(:user)

          tag_name = 'fake_tag'

          expected_body = [].to_json

          get :search, params: { user_id: user.id, tag: tag_name }

          expect(response.body).to eq(expected_body)
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when user is not found' do
        it 'returns http status not found' do
          get :search, params: { user_id: 0, tag: 'some_tag' }

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
