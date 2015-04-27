class NewsnabClient
    include HTTParty
    default_params o: 'json'

    attr_reader :error

    def initialize(url, apikey)
        self.class.base_uri File.join(url, '/api')
        self.class.default_params.merge!(apikey: apikey)
    end

    def valid_apikey?
        (@categories_cache ||= categories).present?
    end

    def get_nzb(wish_result)
        return wish_result.nzb if wish_result.has_nzb?

        resp = self.class.get('', query: { t: 'get', id: wish_result.nzb_id })
        unless (@error = resp["error"])
            Nzb.new(blob: resp.body).tap do |nzb|
                wish_result.downloaded = true
                wish_result.nzb        = nzb
                wish_result.save
            end
        end
    end

    def categories
        return @categories_cache unless @categories_cache.nil?

        resp = self.class.get('', query: { t: 'caps' })
        unless (@error = resp["error"])
            @categories_cache = resp["categories"]["category"]
        end
    end

    def search(wish, result_limit = nil)
        options = { t: 'search', cat: wish.category_id, q: wish.query, age: wish.age_in_days }
        options.merge!({limit: result_limit}) if result_limit.present?

        resp = self.class.get('', query: options)
        unless (@error = resp["error"])
            [(resp["channel"]["item"] || [])].flatten
        end
    end
end