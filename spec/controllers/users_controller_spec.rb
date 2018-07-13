describe UsersController, type: :controller do
  describe 'GET #show' do
    it 'returns user json data and http status success' do
      user = create :user
      expected_response = user.to_json

      get :show, params: { id: user.id }

      expect(response.body).to eq(expected_response)
      expect(response).to have_http_status(:success)
    end

    context 'when user is not found' do
      it 'return an empty json and http status not found' do
        non_existent_user_id = 0
        expected_response = {}.to_json

        get :show, params: { id: non_existent_user_id }

        expect(response.body).to eq(expected_response)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
