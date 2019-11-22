class CreatePostCategoryLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :post_category_links do |t|
      t.integer :post_id
      t.integer :category_id

      t.timestamps
    end
  end
end
