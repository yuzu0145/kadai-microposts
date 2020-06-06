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
end
