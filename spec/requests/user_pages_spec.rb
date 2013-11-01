# encoding: utf-8

require 'spec_helper'

describe "ユーザーページ" do
  
  # テストサンプルのデフォルトとして設定
  subject { page }

  describe "プロフィールページ" do
    
    # user変数を定義
    # FactoryGirlメソッドを使用してUserのファクトリーを作成（FactoryGirlのファクトリーはすべてspec/factories.rbファイルに置く）
    let(:user) { FactoryGirl.create(:user) }
    
    # 前処理　URLパスにアクセスする
    before { visit user_path(user) }
    
    # 内容を持たなければなりません
    it { should have_content(user.name) }
    
    # タイトルを持たなければなりません
    it { should have_title(user.name) }
  end

  describe "サインアップページ" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end
  
  describe "サインアップ" do
    
    # 前処理　ページを参照
    before { visit signup_path }
    
    # submit変数を定義
    let(:submit) { "Create my account" }

    describe "無効な情報で" do
      it "ユーザーをつくってはいけません" do
        # click_button は、文字通りボタンをクリックするメソッド
        # ボタンの上に描かれている文字列（画像ボタンの場合は alt 属性に指定されている文字列）を引数に指定する
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "有効な情報で" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "ユーザーをつくらなければなりません" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end