class Wish < ActiveRecord::Base
    include ActionView::Helpers::DateHelper
    before_create :set_start_search_date

    validates :name,        presence: { message: "Name is required!" }
    validates :query,       presence: { message: "You have to supply a search query!" }
    validates :category_id, presence: { message: "You have to select a category!" }

    belongs_to :category

    has_many :results, foreign_key: :wish_id, class_name: "WishResult", dependent: :destroy

    def self.unfulfilled
        eager_load(:category, :results).where(fulfilled: false).order(:created_at)
    end

    def self.fulfilled
        eager_load(:category, :results).where(fulfilled: true).order(:created_at)
    end

    def age_in_days
        ((Time.now.utc - self.start_search_date.utc) / 1.day).ceil
    end

    def last_search_age
        if self.last_search_date.nil?
            'N/A'
        else
            distance_of_time_in_words(Time.now.utc, self.last_search_date)
        end
    end

    def has_results?
        results.any?
    end

    def as_json(options = nil)
        attributes.merge(category: category.attributes).as_json
    end

    private

    def set_start_search_date
        self.start_search_date = Time.now.utc
    end
end
