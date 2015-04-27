class AddDownloadedToWishResult < ActiveRecord::Migration
  def change
    add_column :wish_results, :downloaded, :boolean, null: false, default: false
  end
end
