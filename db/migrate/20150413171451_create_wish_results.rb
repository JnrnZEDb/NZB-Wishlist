class CreateWishResults < ActiveRecord::Migration
  def change
    create_table :wish_results do |t|
      t.references :wish, index: true, foreign_key: true
      t.string :nzb_id, index: true, null: false
      t.string :title, null: false
      t.references :category, index: true, foreign_key: true
      t.datetime :pub_date, null: false
      t.column :size, :bigint, null: false
      t.string :details_url, null: false

      t.timestamps null: false
    end
  end
end
