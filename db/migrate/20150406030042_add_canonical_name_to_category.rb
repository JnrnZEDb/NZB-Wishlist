class AddCanonicalNameToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :canonical_name, :string
    add_index :categories, :parent_id
  end
end
