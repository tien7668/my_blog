class Category < ApplicationRecord
  has_many :post_category_links
  has_many :posts, through: :post_category_links
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates :name, presence: true, allow_blank: false

  scope :ordered, ->() { order("users.created_at desc") }

  def self.options_for_select
    order('LOWER(name)').map { |e| [e.name, e.id] }
  end
end
