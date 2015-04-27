RSpec.describe NotificationService, vcr: true do
    let(:apikey)  { pushover_key }
    let(:service) { NotificationService.new(apikey) }

    describe "notify" do
        it "returns an error with an invalid API key" do
            bad_service = NotificationService.new('')
            result = bad_service.notify('This will fail.')

            expect(result["status"]).to eq 0
        end

        it "returns a successful result" do
            result = service.notify('This is from a test.')
            expect(result["status"]).to eq 1
        end
    end
end