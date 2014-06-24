class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.text :url
      t.integer :bookmarks_count, :default => 0

      t.timestamps
    end
  end
end
