describe RepositoriesController, type: :controller do
  describe 'GET #index' do
    it 'returns all repositories as json with http success' do
      repo_one = create(:repository, name: 'awesome_api')
      repo_two = create(:repository, name: 'awesome_front')

      expected_body = [repo_one, repo_two].to_json

      get :index

      expect(response.body).to eq(expected_body)
      expect(response.content_type).to eq 'application/json'
      expect(response).to have_http_status(:success)
    end

    context 'when nested to user' do
      it 'returns user`s repositories as json with http success' do
        user = create(:user, name: 'Bill')

        repo_one = create(:repository, name: 'awesome_api', user: user)
        repo_two = create(:repository, name: 'awesome_front', user: user)

        _other_user_repo = create(:repository)

        expected_body = [repo_one, repo_two].to_json

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
end
