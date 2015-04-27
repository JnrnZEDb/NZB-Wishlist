RSpec.describe NewsnabClient, vcr: true do
    let(:url)    { newsnab_url }
    let(:apikey) { newsnab_key }
    let(:client) { NewsnabClient.new(url, apikey) }

    describe 'invalid API key' do
        it 'returns false and sets the error attribute' do
            bad_client = NewsnabClient.new(newsnab_url, '')
            valid_key = bad_client.valid_apikey?

            expect(valid_key).to be false
            expect(bad_client.error).not_to be_nil
        end
    end

    describe 'categories' do
        it 'returns all configured newsnab categories' do
            cats = client.categories
            expect(cats).not_to be_nil
            expect(client.error).to be_nil
        end
    end

    describe 'search' do
        let(:wish) { FactoryGirl.create(:wish) }

        it 'returns all search results for a wish' do
            results = client.search(wish)

            expect(results).to be_a Array
            expect(client.error).to be_nil
        end
    end
end