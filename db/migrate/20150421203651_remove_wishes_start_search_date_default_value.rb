class RemoveWishesStartSearchDateDefaultValue < ActiveRecord::Migration
  def change
    change_column_default(:wishes, :start_search_date, nil)
  end
end
