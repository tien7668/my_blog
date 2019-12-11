class AddStaticIdToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :static_id, :string
  end
end
