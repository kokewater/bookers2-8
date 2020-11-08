class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  attachment :profile_image, destroy: false
  
  include JpPrefecture
  jp_prefecture :prefecture_code  
  # prefecture_codeはuserが持っているカラム
  
  # // postal_codeからprefecture_nameに変換するメソッドを用意します．
  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end
  
  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  # ====================自分がフォローしているユーザーとの関連 ===================================
  #フォローする側のUserから見て、フォローされる側のUserを(中間テーブルを介して)集める。親はfollowed_id(フォローする側)
  has_many :active_relationships, class_name: "Relationship", foreign_key: :followed_id, dependent: :destroy
  # 中間テーブルを介して「follower」モデルのUser(フォローされた側)を集めることを「followings」と定義
  has_many :followings, through: :active_relationships, source: :follower
  
  
  # ====================自分がフォローされるユーザーとの関連 ===================================
  #フォローされる側のUserから見て、フォローしてくる側のUserを(中間テーブルを介して)集める。親はfollower_id(フォローされる側)
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  # 中間テーブルを介して「followed」モデルのUser(フォローする側)を集めることを「followers」と定義
  has_many :followers, through: :passive_relationships, source: :followed
  
  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50 }
  
  def followed_by?(user)
    passive_relationships.find_by(followed_id: user.id).present?
  end
  
  def User.search(search, user_or_book, how_search)
    if user_or_book == "user"
      if how_search == "match"
        User.where(['name LIKE ?', "#{search}"])
      elsif how_search == "forward"
        User.where(['name LIKE ?', "#{search}%"])
      elsif how_search == "backward"
        User.where(['name LIKE ?', "%#{search}"])
      elsif how_search == "partical"
        User.where(['name LIKE ?', "%#{search}%"])
      else
        User.none
      end
    end
  end
  
end