require 'rails_helper'

RSpec.describe WishlistController, type: :controller do
    let!(:settings) { FactoryGirl.create(:setting) }

    describe "when settings aren't complete" do
        describe "GET #index" do
            it "redirects to the settings page" do
                # Due to the before_save filter in Setting, have to manually 'uncomplete' setup.
                settings.update_column(:setup_complete, false)
                get :index
                expect(response.status).to eq(302)
            end
        end
    end

    describe "when settings are complete" do
        describe "GET #index" do
            it "loads all of the unfulfilled wishes into @wishes" do
                get :index
                expect(assigns(:wishes)).not_to be_nil
            end
        end

        describe "GET #fulfilled" do
            it "loads all of the fulfilled wishes into @wishes" do
                get :index
                expect(assigns(:wishes)).not_to be_nil
            end
        end
    end
end