RSpec.describe WishService, vcr: true do
    let(:url)     { newsnab_url }
    let(:apikey)  { newsnab_key }
    let(:client)  { NewsnabClient.new(url, apikey) }
    let(:service) { WishService.new(client) }
    let(:wish)    { FactoryGirl.create(:wish, category_id: 4000) }

    describe "search_newsnab" do
        it "returns a result with added and updated counts" do
            result = service.search_newsnab(wish)

            expect(result.data[:added]).to be_a Integer
            expect(result.data[:updated]).to be_a Integer
        end

        it "populates wish results for the given wish" do
            wish.start_search_date = Time.new(2015, 1, 1) # backdating to get results
            result = service.search_newsnab(wish)

            expect(result.data[:added]).to be > 0
            expect(wish.results.count).to be > 0
        end

        it "updates the last_search_date of the wish" do
            previous_last_date = wish.last_search_date
            service.search_newsnab(wish)

            expect(wish.last_search_date).not_to eq previous_last_date
        end
    end
end