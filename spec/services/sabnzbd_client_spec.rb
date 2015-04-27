RSpec.describe SabnzbdClient, vcr: true do
    let(:url)    { sabnzbd_url }
    let(:apikey) { sabnzbd_key }
    let(:client) { SabnzbdClient.new(url, apikey) }

    describe 'invalid API key' do
        it 'returns nil and sets the error attribute' do
            bad_client = SabnzbdClient.new(url, '')
            cats = bad_client.categories

            expect(cats).to be_nil
            expect(bad_client.error).not_to be_nil
        end
    end

    describe 'categories' do
        it 'returns an array of all the current SABnzbd categories' do
            cats = client.categories
            expect(cats).to be_a Array
        end
    end

    describe 'queue' do
        it 'returns the current SABnzbd queue' do
            queue = client.queue
            expect(queue).not_to be_nil
        end
    end

    describe 'upload_nzb' do
        it 'uploads the nzb to SABnzbd' do
            nzb = FactoryGirl.create(:nzb)
            result = client.upload_nzb(nzb)
            expect(result["status"]).not_to be_nil
        end
    end
end