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

  def admin?
    self.role == "admin" || false
  end
  def user?
    self.role == "user" || false
  end
end
