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
end
