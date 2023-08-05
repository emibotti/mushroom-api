require 'rails_helper'

RSpec.describe MyceliaController, type: :controller do
  let(:mycelium) { create(:mycelium) }

  let(:user) { create(:user) } # Assuming you have a factory for User

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      create_list(:mycelium, 3)
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: mycelium.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(mycelium.id)
    end

    it 'returns a not found response when mycelium does not exist' do
      get :show, params: { id: 'non_existent_id' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      attributes_for(:mycelium).merge(
        type: 'Culture',
        prefix: 'Prefix',
        quantity: 5
      )
    end

    let(:invalid_attributes) { valid_attributes.merge(name: nil) }

    context 'with valid params' do
      it 'creates the specified quantity of Mycelium' do
        expect {
          post :create, params: { mycelium: valid_attributes, quantity: valid_attributes[:quantity] }
        }.to change(Mycelium, :count).by(valid_attributes[:quantity])
      end

      it 'renders a JSON response with a success message' do
        post :create, params: { mycelium: valid_attributes, quantity: valid_attributes[:quantity] }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq("#{valid_attributes[:quantity]} mycelia created successfully")
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors' do
        post :create, params: { mycelium: invalid_attributes, quantity: valid_attributes[:quantity] }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with invalid strain_source_id' do
      it 'renders a JSON response with an error message' do
        post :create, params: { mycelium: valid_attributes.merge(strain_source_id: -1), quantity: valid_attributes[:quantity] }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # Similar tests for update, destroy, etc.
end
