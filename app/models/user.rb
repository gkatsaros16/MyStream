class User < ApplicationRecord
  acts_as_voter

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :follower_relationships, foreign_key: :following_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower
  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow'
  has_many :following, through: :following_relationships, source: :following

  has_attached_file :avatar, styles: { medium: "200x200>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  validates :user_name, presence: true, length: { minimum: 4, maximum: 12 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def follow(user_id)
    following_relationships.create(following_id: user_id)
  end

  def unfollow(user_id)
    following_relationships.find_by(following_id: user_id).destroy
  end
end
