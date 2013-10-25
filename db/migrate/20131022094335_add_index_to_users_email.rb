# encoding: utf-8
class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    # users　テーブルの　email　カラムにインデックスを追加する（オプションで一意性を強制する）
    add_index :users, :email, unique: true
  end
end
