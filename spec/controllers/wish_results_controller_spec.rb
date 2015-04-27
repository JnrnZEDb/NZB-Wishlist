require 'rails_helper'

RSpec.describe WishResultsController, type: :controller, vcr: true do
    let!(:settings)   { FactoryGirl.create(:setting) }
    let(:wish)        { FactoryGirl.create(:wish) }
    let(:nzb)         { FactoryGirl.create(:nzb) }

    describe "GET #index" do
        it "redirects to the root path if the wish is invalid" do
            get :index, wish_id: 0
            expect(response).to redirect_to '/'
        end

        it "renders the index template" do
            get :index, wish_id: wish.id
            expect(response).to render_template :index
        end
    end

    describe "GET #download" do
        it "returns the nzb for the result" do
            get :download, { wish_id: wish.id, id: nzb.wish_result.id }
            expect(response.content_type).to eq 'application/x-nzb'
        end

        it "redirects to the root path when the wish result is invalid" do
            get :download, { wish_id: wish.id, id: 0 }
            expect(response).to redirect_to '/'
        end
    end

    describe "POST #send_to_sabnzbd" do
        it "attempts to send the nzb to SABnzbd" do
            post :send_to_sabnzbd, { wish_id: wish.id, id: nzb.wish_result.id }
            expect(JSON.parse(response.body)["success"]).not_to be_nil
        end
    end
end