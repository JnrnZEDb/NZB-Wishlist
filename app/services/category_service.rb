class CategoryService < NewsnabService

    def populate_from_newsnab(force = false)
        categories = @client.categories
        return bad_result if categories.nil?

        if Category.count == 0 || force
            Category.transaction do
                Category.delete_all
                categories.each do |category|
                    map_from_newsnab_category(category).save
                end
            end
            return good_result
        end

        good_result('Nothing to do.')
    end

    private

    def map_from_newsnab_category(newsnab_category, parent_category = nil)
        attrs = newsnab_category["@attributes"]

        (Category.where(id: attrs["id"]).first || Category.new(id: attrs["id"])).tap do |category|
            if parent_category.nil?
                category.name = category.canonical_name = attrs["name"]
            else
                category.name = attrs["name"]
                category.canonical_name = "#{parent_category.name}/#{attrs["name"]}"
                category.parent_id = parent_category.id
            end

            (newsnab_category["subcat"] || []).each do |subcat|
                category.children << map_from_newsnab_category(subcat, category)
            end
        end
    end

end