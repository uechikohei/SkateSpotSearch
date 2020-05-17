class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  mount_uploader :image, ImageUploader
  validates :name, presence: true, length: { maximum: 20}

  # mapテーブルと1対多になる。ユーザが削除＝投稿も削除
  has_many :maps, dependent: :destroy
  # likeテーブルと1対多になる。ユーザが削除＝投稿も削除
  has_many :likes, dependent: :destroy
  # ユーザが、どの投稿をいいねしているか取得
  has_many :liked_maps, through: :likes, source: :map

  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # フォロー取得
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy # フォロワー取得

  has_many :following_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人

  # ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end

  # 最近作成されたユーザーから表示
  default_scope -> { order(created_at: :desc) }
  # 一度に表示する投稿数
  paginates_per 6

  # ユーザが投稿に対し、いいね済かcheckするメソッドを定義
  def already_liked?(map)
    self.likes.exists?(map_id: map.id)
  end

  # 簡単ログインユーザー作成
  def self.guest
    image_path = open("./db/fixtures/faker_user_image.png")
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guest_user"
      user.image = image_path
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
  end
end
