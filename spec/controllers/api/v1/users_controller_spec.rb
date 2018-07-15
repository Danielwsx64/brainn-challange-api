describe Api::V1::UsersController, type: :controller do
  describe 'GET #show' do
    it 'returns user json data and http status success' do
      user = create :user
      expected_response = user.to_json

      get :show, params: { id: user.id }

      expect(response.body).to eq(expected_response)
      expect(response.content_type).to eq 'application/json'
      expect(response).to have_http_status(:success)
    end

    context 'when user is not found' do
      it 'return an empty json and http status not found' do
        non_existent_user_id = 0
        expected_response = {}.to_json

        get :show, params: { id: non_existent_user_id }

        expect(response.body).to eq(expected_response)
        expect(response.content_type).to eq 'application/json'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    it 'creates a user' do
      user_params = { name: 'Alan' }

      expect do
        post :create, params: { user: user_params }
      end.to change(User, :count).from(0).to(1)
    end

    it 'return json data with http status created' do
      user_params = { name: 'Alan' }

      post :create, params: { user: user_params }

      parsed_body = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_body).to include user_params
      expect(response.content_type).to eq 'application/json'
      expect(response).to have_http_status(:created)
    end

    context 'when invalid params' do
      it 'return http status bad_request' do
        user_params = 'invalid_params'

        post :create, params: { user: user_params }

        expect(response.body).to include 'bad request'
        expect(response.content_type).to eq 'application/json'
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
