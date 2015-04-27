class WishController < ApplicationController
    before_filter :get_wish, only: [:update, :destroy]

    def create
        @wish = Wish.create(wish_params)
        if @wish.valid?
            success wish: @wish
        else
            failure errors: @wish.errors
        end
    end

    def update
        if @wish.update_attributes(wish_params)
            success wish: @wish
        else
            failure errors: @wish.errors
        end
    end

    def destroy
        success wish: @wish.destroy
    end

    private

    def wish_params
        params.require(:wish).permit(:id, :name, :query, :category_id, :fulfilled)
    end

    def get_wish
        @wish = Wish.where(id: wish_params[:id]).first
        return failure error: 'Invalid wish' if @wish.nil?
    end

end
