class WishlistController < ApplicationController

    def index
        @wishes = Wish.unfulfilled
    end

    def fulfilled
        @wishes = Wish.fulfilled
    end

end
