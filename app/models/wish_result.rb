class WishResult < ActiveRecord::Base
    include ActionView::Helpers::NumberHelper
    include ActionView::Helpers::DateHelper

    validates :title,       presence: true
    validates :wish_id,     presence: true
    validates :nzb_id,      presence: true
    validates :category_id, presence: true
    validates :pub_date,    presence: true
    validates :size,        presence: true
    validates :details_url, presence: true

    belongs_to :wish
    belongs_to :category
    has_one    :nzb, dependent: :destroy

    scope :by_pub_date, -> { order(pub_date: :desc) }

    def human_readable_size
        number_to_human_size(self.size)
    end

    def publish_age
        distance_of_time_in_words(Time.now.utc, self.pub_date)
    end

    def has_nzb?
        Nzb.exists?(wish_result_id: self.id)
    end
end
