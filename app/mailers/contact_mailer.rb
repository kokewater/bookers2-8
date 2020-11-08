class ContactMailer < ApplicationMailer
  def welcome#メソッドに対して引数を設定
    @user = user #ユーザー情報
    mail to: @user.email, subject: 'ククク、私のサイトへようこそ！'
  end
end