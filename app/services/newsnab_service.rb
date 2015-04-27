class NewsnabService

    def initialize(newsnab_client)
        @client = newsnab_client
    end

    protected

    def bad_result(message = nil, data = {})
        ServiceResult.new(false, message || @client.error["description"], data)
    end

    def good_result(message = nil, data = {})
        ServiceResult.new(true, message, data)
    end
end