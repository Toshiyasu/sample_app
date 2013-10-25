# encoding: utf-8
class User < ActiveRecord::Base
  # email属性を小文字に変換してメールアドレスの一意性を保証する
  before_save { self.email = email.downcase }
  
  validates :name, presence: true, length: { maximum: 50 }
  
  # 正規表現の定数
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  
  # パスワードの存在検証と確認、認証をするメソッド
  has_secure_password
  
  validates :password, length: { minimum: 6 }
end
