RSpec.describe CategoryService, vcr: true do
    let(:url)     { newsnab_url }
    let(:apikey)  { newsnab_key }
    let(:client)  { NewsnabClient.new(url, apikey) }
    let(:service) { CategoryService.new(client) }

    describe "populate_from_newsnab" do
        before :each do
            # ensure there's nothing in the Category table
            Category.destroy_all
            # populate categories
            service.populate_from_newsnab
        end

        it "populates categories from newsnab when there are none." do
            expect(Category.count).to be > 0
        end

        it "forcibly populates categories from newsnab when instructed" do
            # Ensure we didn't get back 'Nothing to do' in the message
            result = service.populate_from_newsnab(force: true)
            expect(result.message).to be_nil
        end

        it "does nothing when categories are present and is not forced to act" do
            # Ensure we get back a message to the effect of there was nothing done
            result = service.populate_from_newsnab
            expect(result.message).not_to be_nil
        end
    end
end