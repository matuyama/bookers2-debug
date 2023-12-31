class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  has_many :followers, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following_users, through: :followers, source: :followed

  has_many :followeds, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :follower_users, through: :followeds, source: :follower

    # フォローをした時
  def follow(user_id)
    followers.create(followed_id: user_id)
  end

  # フォローを外した
  def unfollow(user_id)
    followers.find_by(followed_id: user_id).destroy
  end

  # フォローしているか判定
  def following?(user)
    following_users.include?(user)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?", "#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?", "%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?", "%#{word}%")
    else
      @user = User.all
    end
  end

  # DM機能
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :room, through: :entries


  has_one_attached :profile_image

  validates :name, {presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: true}
  validates :introduction, length: {maximum: 50 }

  has_many :view_counts, dependent: :destroy
  
  has_many :group_users, dependent: :destroy

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

end
