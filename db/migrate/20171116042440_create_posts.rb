class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.text :content
      t.string :slug
      t.string :photo
      t.integer :status

      t.timestamps
    end
  end
end
