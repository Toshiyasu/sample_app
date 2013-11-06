# encoding: utf-8
require 'spec_helper'

describe User do
  
  # before　は前処理
  before { @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar") }
  
  # テストサンプルのデフォルトとして設定
  subject { @user }
  
  # 存在をテスト
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  
  # @user　という　subject　が有効であることを確認
  it { should be_valid }
  
  describe "名前が存在しないとき" do
    # 無効な値を設定
    before { @user.name = " " }
    # 無効であることを確認
    it { should_not be_valid }
  end
  
  describe "メールアドレスが存在しないとき" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  describe "名前があまりに長いとき" do
    before {@user.name = "a" * 51}
    it { should_not be_valid }
  end
  
  describe "メールアドレスのフォーマットが無効であるとき" do
    it "無効でなければなりません" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  
  describe "メールアドレスが有効であるとき" do
    it "有効でなければなりません" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end
  
  describe "メールアドレスが既に登録されているとき" do
    before do
      # 同じ属性を持つ重複ユーザーを作成
      user_with_same_email = @user.dup
      # メールアドレスを大文字に変換（メールアドレスは大文字小文字が区別されないため）
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    
    it { should_not be_valid }
  end
  
  describe "パスワードが存在しないとき" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com", password: "", password_confirmation: "")
    end
    it { should_not be_valid }
  end
  
  describe "パスワード確認とマッチしないとき" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "パスワードがあまりに短いとき" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  
  describe "authenticateメソッドの値を返す" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }
    
    describe "有効なパスワードで" do
      it { should eq found_user.authenticate(@user.password) }
    end
    
    describe "無効なパスワードで" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
  
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end