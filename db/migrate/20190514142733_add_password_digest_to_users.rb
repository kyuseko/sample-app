class AddPasswordDigestToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password_digest, :string   # モデルにpassword_digestというカラムを含めるだけです。
  end                                              # has_secure_passwordの機能を利用するため
end                                               # そのままの文字列ではなく、ハッシュ化して保存するため
