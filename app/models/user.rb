class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  # 「remember_token」という仮想の属性を作成します。
  attr_accessor :remember_token
  before_save { self.email = email.downcase }                   # データベースに保存する前に小文字に変換します。
  
                                                                 # 存在性の検証（presence）
  validates :name,  presence: true, length: { maximum: 50 }      # 存在性 50文字以下であること
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i       # 存在性 メールアドレスのフォーマットを検証できる 一意であること
  validates :email, presence: true, length: { maximum: 100 },   # 100文字以下であること
                    format: { with: VALID_EMAIL_REGEX },        # この正規表現でメールアドレスのフォーマットを検証できる
                    uniqueness: true    # データベースレベルで一意性の検証 emailカラムにインデックスを追加
                    
  has_secure_password   #dbのpassword_digestに保存できる 存在性と値が一致するか検証 authenticateメソッドが使用可能
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64  # ランダムに生成したトークンをハッシュ化（ダイジェストとして保存するため）する準備は整いました。
  end
  
  # 永続セッションのためハッシュ化したトークンをデータベースに記憶します。
  def remember
    self.remember_token = User.new_token # selfを記述することで仮想のremember_token属性にUser.new_tokenで生成した「ハッシュ化されたトークン情報」を代入
    update_attribute(:remember_digest, User.digest(remember_token))  # トークンダイジェストを更新 
  end                                                                # 末尾にsがあるかない バリデーションを素通りさせます
  # user.rememberが動作するようになりました
  
  # トークンがダイジェストと一致すればtrueを返します。
  def authenticated?(remember_token)      # cookiesに保存されているremember_tokenがdbにあるremember_digestと一致することを確認（トークン認証）
      # ダイジェストが存在しない場合はfalseを返して終了します。
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄します。
  def forget
    update_attribute(:remember_digest, nil)
  end
  # 永続的セッションを終了する準備が整います
  # Sessionsヘルパーモジュールにforgetヘルパーメソッドを追加してそれをlog_outヘルパーメソッドから呼び出します。
end
