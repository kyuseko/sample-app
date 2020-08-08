class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email, unique: true  # 検索を早くする仕組み（索引）一意性を強制すること
  end
end
