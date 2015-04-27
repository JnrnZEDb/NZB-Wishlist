module QueueHelper

    def format_category(category)
        return 'Default' if category == '*'
        category.length > 3 ? category.titlecase : category.upcase
    end
end
