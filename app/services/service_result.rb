class ServiceResult

    attr_reader :success, :message, :data

    def initialize(success, message, data = {})
        @success = success
        @message = message
        @data = data
    end

    def successful?
        @success
    end

    def failed?
        !@success
    end
end