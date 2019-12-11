class AddMultilangToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :name_en, :string
    add_column :categories, :name_jp, :string
  end
end
