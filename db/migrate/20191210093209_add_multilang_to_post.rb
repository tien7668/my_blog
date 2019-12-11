class AddMultilangToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :title_en, :string
    add_column :posts, :content_en, :text
    add_column :posts, :title_jp, :string
    add_column :posts, :content_jp, :text
  end
end
