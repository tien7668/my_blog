class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  extend FriendlyId
  friendly_id :title, use: :slugged
  scope :ordered, ->() { order("users.created_at asc") }
end
