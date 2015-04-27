require 'rails_helper'

RSpec.describe QueueController, type: :controller, vcr: true do
    let!(:settings) { FactoryGirl.create(:setting) }

    describe 'GET #index' do
        it 'populates @queue' do
            get :index
            expect(assigns(:queue)).not_to be_nil
        end

        it 'renders the index template with no format specified' do
            get :index
            expect(response).to render_template :index
        end

        it 'renders json with the requested format' do
            get :index, format: :json
            expect(response.content_type).to eq 'application/json'
        end
    end

    describe 'GET #action' do
        it 'returns a failed status for a bad action' do
            get :action, { request: { action: 'doesnt_exist' } }
            expected = { status: false }.to_json

            expect(response.content_type).to eq 'application/json'
            expect(response.body).to eq expected
        end
    end
end