require 'rails_helper'

RSpec.describe SettingsController, type: :controller, vcr: true do
    let!(:settings) { FactoryGirl.create(:setting) }

    describe "GET #edit" do
        it 'renders the settings page' do
            get :edit, { id: settings.id }
            expect(response).to render_template :edit
        end
    end

    describe "GET #validate_newsnab_key" do
        let(:url) { newsnab_url }
        let(:key) { newsnab_key }

        it "validates the newsnab url and apikey successfully" do
            get :validate_newsnab_key, { url: url, key: key }
            expect(JSON.parse(response.body)["success"]).to eq true
        end

        it "fails an invalid URL" do
            get :validate_newsnab_key, { url: 'not_valid', key: key }
            expect(JSON.parse(response.body)["success"]).to eq false
        end

        it "fails an invalid api key" do
            get :validate_newsnab_key, { url: url, key: 'abc123' }
            expect(JSON.parse(response.body)["success"]).to eq false
        end
    end

   describe "GET #validate_sabnzbd_key" do
        let(:url) { sabnzbd_url }
        let(:key) { sabnzbd_key }

        it "validates the sabnzbd url and apikey successfully" do
            get :validate_sabnzbd_key, { url: url, key: key }
            expect(JSON.parse(response.body)["success"]).to eq true
        end

        it "fails an invalid URL" do
            get :validate_sabnzbd_key, { url: 'not_valid', key: key }
            expect(JSON.parse(response.body)["success"]).to eq false
        end

        it "fails an invalid api key" do
            get :validate_sabnzbd_key, { url: url, key: 'abc123' }
            expect(JSON.parse(response.body)["success"]).to eq false
        end
    end
end