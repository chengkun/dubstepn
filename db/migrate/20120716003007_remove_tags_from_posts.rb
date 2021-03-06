class RemoveTagsFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :tags
  end

  def down
    add_column :posts, :tags, :text
    change_column :posts, :tags, :text, :null => false
  end
end
