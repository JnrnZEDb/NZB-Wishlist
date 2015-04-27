class NotificationService
    MAX_MESSAGE_LENGTH = 1024
    ENDPOINT           = 'https://api.pushover.net/1/messages.json'
    private_constant :ENDPOINT

    def initialize(apikey)
        @userkey = apikey
        @appkey  = Rails.application.secrets[:pushover_app_key]
    end

    def notify(message)
        params = { user: @userkey, token: @appkey, message: message }
        HTTParty.post(ENDPOINT, body: params).parsed_response
    end

end