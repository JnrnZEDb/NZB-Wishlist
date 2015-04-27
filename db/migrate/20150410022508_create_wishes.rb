class CreateWishes < ActiveRecord::Migration
  def change
    create_table :wishes do |t|
      t.string :name
      t.string :query
      t.boolean :fulfilled, null: false, default: false
      t.references :category, index: true, foreign_key: true
      t.datetime :last_search_date
      t.datetime :start_search_date, null: false, default: Time.now

      t.timestamps null: false
    end
  end
end
