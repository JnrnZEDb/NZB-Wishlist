class CreateNzbs < ActiveRecord::Migration
  def change
    create_table :nzbs do |t|
      t.references :wish_result, index: true, foreign_key: true
      t.binary :blob
    end
  end
end
