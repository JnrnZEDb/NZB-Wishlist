class WishService < NewsnabService

    def search_newsnab(wish, result_limit = nil)
        result = @client.search(wish, result_limit)

        if @client.error
            bad_result
        else
            populate_wish_results(wish, result)
        end
    end

    private

    def populate_wish_results(wish, result)
        begin
            stats = { added: 0, updated: 0 }
            Wish.transaction do
                wish.last_search_date = Time.now.utc
                result.each do |r|
                    wish_result = map_result_to_wish_result(wish, r)

                    if wish_result.new_record?
                        stats[:added] += 1
                        wish.results << wish_result
                    else
                        stats[:updated] += 1
                        wish_result.save
                    end
                end
                wish.save
            end
            good_result "#{result.count} results found.", stats
        rescue => e
            bad_result "Failed to process results.", exception: e.message
        end
    end

    def map_result_to_wish_result(wish, result)
        (wish.results.find { |wr| wr.nzb_id == result["guid"] } || WishResult.new(nzb_id: result["guid"])).tap do |wish_result|
            wish_result.title       = result["title"]
            wish_result.details_url = result["comments"].gsub(/\#comments/, '#details')
            wish_result.pub_date    = result["pubDate"]
            wish_result.category_id = get_category_id(result["attr"])
            wish_result.size        = result["enclosure"]["@attributes"]["length"].to_i
        end
    end

    def get_category_id(attributes)
        attributes
            .map { |a| a["@attributes"] if a["@attributes"]["name"] == 'category' }
            .compact
            .map { |a| a["value"].to_i }
            .max
    end
end