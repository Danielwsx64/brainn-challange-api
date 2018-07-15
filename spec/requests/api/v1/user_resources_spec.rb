describe 'User management', type: :request do
  include Docs::V1::Users::Api

  describe 'GET /api/v1/users/:id' do
    include Docs::V1::Users::Show

    it 'returns an user', :dox do
      user = create(:user)
      expected_response = user.to_json

      get api_v1_user_path(user)

      expect(response.body).to eq(expected_response)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /api/v1/users' do
    include Docs::V1::Users::Create

    it 'creates a user', :dox do
      user_params = { name: 'Bill' }

      post api_v1_users_path, params: { user: user_params }

      parsed_body = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_body).to include user_params
      expect(response.content_type).to eq 'application/json'
      expect(response).to have_http_status(:created)
    end
  end
end
