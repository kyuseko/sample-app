class CreateUsers < ActiveRecord::Migration[5.1]
  def change                     # ファイル自体はデータベースに与える変更を定義したchangeメソッドの集まり
    create_table :users do |t|   # usersテーブルを作成
      t.string :name             # ブロックの中でnameとemailカラムをデータベースに作成
      t.string :email            # テーブル名はusersと複数形

      t.timestamps
    end
  end
end
