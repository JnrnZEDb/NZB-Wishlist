class AddNewsnabUrlToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :newsnab_url, :string
  end
end
