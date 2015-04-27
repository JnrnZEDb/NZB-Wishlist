require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
    let!(:settings) { FactoryGirl.create(:setting) }

    describe "GET #index" do
        it "returns json serialized categories" do
            get :index
            expect(response.content_type).to eq 'application/json'
        end
    end
end