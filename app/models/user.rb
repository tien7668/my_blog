class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:admin, :user]

  extend FriendlyId
  friendly_id :username, use: :slugged

  has_many :posts
  has_many :comments
  scope :ordered, ->() { order("users.created_at desc") }

  scope :search, lambda { |q|
    query = "%"+q.to_s.downcase+"%"
    where("lower(cast (users.name as text)) LIKE ? or
                lower(cast (users.email as text)) LIKE ? or
                lower(cast (users.username as text)) LIKE ? ", query, query, query)
  }

  def admin?
    self.role == "admin" || false
  end
  def user?
    self.role == "user" || false
  end
end
