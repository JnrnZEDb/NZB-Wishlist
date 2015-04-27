class Category < ActiveRecord::Base
    validates :name, presence: true
    validates :canonical_name, presence: true

    belongs_to :parent, foreign_key: :parent_id, class_name: "Category"
    has_many :children, foreign_key: :parent_id, class_name: "Category", dependent: :destroy
end
