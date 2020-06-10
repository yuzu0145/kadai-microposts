class User < ApplicationRecord
    #文字をすべて小文字にする
    before_save { self.email.downcase! }
    #nameはカラ文字なしの長さ50文字
    validates :name, presence: true, length: { maximum: 50 }
    #emailはカラ文字なしの長さ250文字
    validates :email, presence: true, length: { maximum: 255 },         
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
    has_secure_password
    
    has_many :microposts
    
    #右側の自分がフォローしているUserへの参照
    #Userから見た中間テーブル
    has_many :relationships
    
    #user.followingsの機能提供
    #throughで中間テーブルを経由して相手情報を取得
    has_many :followings, through: :relationships, source: :follow
    
=begin 
user.followings というメソッドを用いると、 
user が中間テーブル relationships を取得し、
その1つ1つの relationship の follow_id から
自分がフォローしている User 達 を取得するという処理が可能になります
=end
    
    
   #左側の自分をフォローしているUserへの参照
    has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
    
    #user.followersの機能提供
    has_many :followers, through: :reverses_of_relationship, source: :user

#フォローしようとしている人(other_user) が自分自身ではないか
#self=User
    def follow(other_user)
     unless self == other_user
        self.relationships.find_or_create_by(follow_id: other_user.id)
     end
    end

    def unfollow(other_user)
        relationship = self.relationships.find_by(follow_id: other_user.id)
        relationship.destroy if relationship
    end

    def following?(other_user)
        self.followings.include?(other_user)
    end
    
     def feed_microposts
        Micropost.where(user_id: self.following_ids + [self.id])
     end
end