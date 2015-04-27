class CategoriesController < ApplicationController

    def index
        render json: Category.order(:id).all
    end
end
