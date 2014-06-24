class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.integer :user_id
      t.integer :link_id
      t.string :title
      t.text :notes

      t.timestamps
    end
  end
end
