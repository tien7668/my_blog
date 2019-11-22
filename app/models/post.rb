class Post < ApplicationRecord
  mount_uploader :photo, ImageUploader

  acts_as_taggable_on :tags
  belongs_to :user
  has_many :post_category_links
  has_many :categories, through: :post_category_links
  has_many :comments
  extend FriendlyId
  friendly_id :title, use: :slugged
  validates :title, :content, presence: true, allow_blank: false

  paginates_per 10
  filterrific(default_filter_params: { sorted_by: 'updated_at_desc' },
              available_filters: [
                  :sorted_by, :search, :with_category_id, :with_tag
              ])
  scope :search, lambda { |q|
    query = "%"+q.to_s.downcase+"%"
    # joins([{document: :cycle}, :product_block])
    # joins(:categories)
    #     .where("lower(cast (posts.title as text)) LIKE ? or
    #             lower(cast (posts.content as text)) LIKE ? or
    #             lower(cast (categories.name as text)) LIKE ?", query, query, query)
    #     .group("posts.id")
    #     .select("max(posts.title), max(posts.content), max(categories.name), posts.created_at")
    where("lower(cast (posts.title as text)) LIKE ? or
                lower(cast (posts.content as text)) LIKE ? ", query, query)
  }

  scope :with_category_id, lambda { |id|
    joins(:categories).where("categories.id = ? ", id)
  }

  scope :with_tag, lambda { |name|
    Post.tagged_with(name)
  }

  scope :ordered, ->() { order("users.created_at desc") }
end