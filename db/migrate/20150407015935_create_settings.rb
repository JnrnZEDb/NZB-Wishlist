class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :newsnab_apikey
      t.integer :result_limit
      t.integer :search_interval
      t.boolean :auto_download
      t.boolean :fulfill_on_download
      t.string :sabnzbd_url
      t.string :sabnzbd_apikey
      t.boolean :notify
      t.string :pushover_apikey
      t.boolean :setup_complete
    end
  end
end
